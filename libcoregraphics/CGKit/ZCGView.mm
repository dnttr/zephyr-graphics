//
//  ZCGView.m
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Foundation/Foundation.h>
#import "AppKit/AppKit.h"
#import "OpenGL/gl3.h"

#import "internal/cg_window_manager.h"

#import "ZCGView.h"

@implementation ZCGView {
    NSRecursiveLock *glLock;
    BOOL needsReshape;
    uint64_t lastReshapeTime;
    
    CFTimeInterval lastFrameTime;
    NSTimeInterval frameTime;
    uint32_t frameCount;
    NSTimeInterval totalFrameTime;
    
    BOOL isDrawing;
    BOOL isInitialized;
    dispatch_semaphore_t drawSemaphore;
}

int backingWidth = 0;
int backingHeight = 0;

static CVReturn callback(CVDisplayLinkRef displayLink,
                         const CVTimeStamp *inNow,
                         const CVTimeStamp *inOutputTime,
                         CVOptionFlags flagsIn,
                         CVOptionFlags *flagsOut,
                         void *displayLinkContext) {
    @autoreleasepool {
        ZCGView *view = (__bridge ZCGView *)displayLinkContext;
        
        if (dispatch_semaphore_wait(view->drawSemaphore, DISPATCH_TIME_NOW) == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [view draw];
                dispatch_semaphore_signal(view->drawSemaphore);
            });
        }
    }
    
    return kCVReturnSuccess;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    NSOpenGLPixelFormatAttribute attrs[] = {
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
        NSOpenGLPFAColorSize, 24,
        NSOpenGLPFADepthSize, 16,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAAccelerated,
        NSOpenGLPFANoRecovery,
        NSOpenGLPFASamples, 1,
        NSOpenGLPFASampleBuffers, 16,
        0
    };
    
    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    
    self = [super initWithFrame:frameRect pixelFormat:pixelFormat];
    
    if (self) {
        glLock = [[NSRecursiveLock alloc] init];
        
        needsReshape = YES;
        
        lastReshapeTime = 0;
        
        isDrawing = NO;
        isInitialized = NO;
        
        lastFrameTime = CACurrentMediaTime();
        
        frameTime = 0;
        frameCount = 0;
        totalFrameTime = 0;
        
        drawSemaphore = dispatch_semaphore_create(1);
        
        [self setWantsBestResolutionOpenGLSurface:YES];
    }
    
    return self;
}

- (void)prepareOpenGL {
    [super prepareOpenGL];
    
    NSLog(@"Preparing OpenGL context");
    
    [glLock lock];
    @try {
        [[self openGLContext] makeCurrentContext];
        
        GLint sync = 1;
        [[self openGLContext] setValues:&sync forParameter:NSOpenGLCPSwapInterval];
        
        const GLubyte* renderer = glGetString(GL_RENDERER);
        const GLubyte* version = glGetString(GL_VERSION);
        
        NSLog(@"Renderer: %s", renderer);
        NSLog(@"OpenGL version: %s", version);
        
        glClearColor(0.2f, 0.2f, 0.2f, 1.0f); //initial color
        
        if (self->_onInitCallback) {
            self->_onInitCallback();
        }
        
        isInitialized = YES;
        
        [self updateGLViewport];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in prepareOpenGL: %@", exception);
    }
    @finally {
        [glLock unlock];
    }
    
    [self setupLink];
}

- (void)updateGLViewport {
    [glLock lock];
    @try {
        NSRect bounds = [self convertRectToBacking:[self bounds]];
        backingWidth = (int)bounds.size.width;
        backingHeight = (int)bounds.size.height;
                
        [[self openGLContext] update];
        
        if (self->_onReshapeCallback) {
            self->_onReshapeCallback(backingWidth, backingHeight);
        }
        
        needsReshape = NO;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in updateGLViewport: %@", exception);
    }
    @finally {
        [glLock unlock];
    }
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boundsDidChange:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:self];
}

- (void)boundsDidChange:(NSNotification *)notification {
    if ([self inLiveResize]) {
        [self updateGLViewport];
    }
}


- (void)reshape {
    [super reshape];
    
    [self updateGLViewport];

    needsReshape = YES;
    lastReshapeTime = dispatch_time(DISPATCH_TIME_NOW, 0);
}

- (void)draw {
    CFTimeInterval currentTime = CACurrentMediaTime();
    CFTimeInterval deltaTime = currentTime - lastFrameTime;
    lastFrameTime = currentTime;
    
    if (isDrawing || !isInitialized) {
        return;
    }
    
    if (![glLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:0.016]]) {
        return;
    }
    
    isDrawing = YES;
    
    @try {
        if (needsReshape) {
            uint64_t now = dispatch_time(DISPATCH_TIME_NOW, 0);
            uint64_t elapsed = now - lastReshapeTime;
            
            if (elapsed > NSEC_PER_MSEC * 16) {
                [self updateGLViewport];
                lastReshapeTime = now;
            }
        }
        
        [[self openGLContext] makeCurrentContext];
        
        if (self->_onUpdateCallback) {
            self->_onUpdateCallback();
        }
        
        if (self->_onRenderCallback) {
            self->_onRenderCallback();
        }
        
        [[self openGLContext] flushBuffer];
        
        frameCount++;
        totalFrameTime += deltaTime;
        if (frameCount >= 60) {
            frameTime = totalFrameTime / frameCount;
            frameCount = 0;
            totalFrameTime = 0;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in draw: %@", exception);
    }
    @finally {
        isDrawing = NO;
        [glLock unlock];
    }
}

- (void)viewWillStartLiveResize {
    [super viewWillStartLiveResize];
}

- (void)viewDidEndLiveResize {
    [super viewDidEndLiveResize];
    
    [glLock lock];
    @try {
        [self updateGLViewport];
    }
    @finally {
        [glLock unlock];
    }
}

- (void)setupLink {
    NSLog(@"Setting up display link");
    
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    CVDisplayLinkSetOutputCallback(displayLink, &callback, (__bridge void *) self);
    
    CGLContextObj context = [[self openGLContext] CGLContextObj];
    CGLPixelFormatObj format = [[self pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, context, format);
    
    CVReturn status = CVDisplayLinkStart(displayLink);
    if (status != kCVReturnSuccess) {
        NSLog(@"Failed to start display link: %d", status);
    } else {
        NSLog(@"Display link started successfully");
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)mouseDown:(NSEvent *)event {
}

- (void)keyDown:(NSEvent *)event {
}

- (void)dealloc {
    NSLog(@"ZCGView dealloc");
    
    if (displayLink) {
        CVDisplayLinkStop(displayLink);
        CVDisplayLinkRelease(displayLink);
        displayLink = nil;
    }
    
    if (self->_onExitCallback) {
        self->_onExitCallback();
    }
}

@end
