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

@implementation ZCGView

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
        
        if (view->_onUpdateCallback) {
            view->_onUpdateCallback();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [view draw];
        });
    }
    
    return kCVReturnSuccess;
}

- (void)prepareOpenGL {
    [super prepareOpenGL];
    [[self openGLContext] makeCurrentContext];
    
    GLint sync = 1;
    [[self openGLContext] setValues:&sync forParameter:NSOpenGLCPSwapInterval];
    
    if (self->_onInitCallback) {
        self->_onInitCallback();
    }
}

- (void)reshape {
    [super reshape];
    
    NSRect bounds = [self convertRectToBacking:[self bounds]];
    backingWidth = (int)bounds.size.width;
    backingHeight = (int)bounds.size.height;
    
    if (self->_onReshapeCallback) {
        self->_onReshapeCallback(backingWidth, backingHeight);
    }
    
    [[self openGLContext] update];
}

- (instancetype)initWithFrame:(NSRect)frameRect {    
    NSOpenGLPixelFormatAttribute attrs[] =
       {
           NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
           NSOpenGLPFAColorSize, 24,
           NSOpenGLPFADepthSize, 16,
           NSOpenGLPFADoubleBuffer,
           NSOpenGLPFAAccelerated,
           NSOpenGLPFASamples, 16,
           NSOpenGLPFASampleBuffers, 1,
           0
       };
    
    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    
    self = [super initWithFrame:frameRect pixelFormat:pixelFormat];
    
    if (self) {
        [self setupLink];
    }
    
    return self;
}

- (void) draw {
    [[self openGLContext] makeCurrentContext];
        
    if (self->_onRenderCallback) {
        self->_onRenderCallback();
    }
    
    [[self openGLContext] flushBuffer];
}

- (void)setupLink {
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    CVDisplayLinkSetOutputCallback(displayLink, &callback, (__bridge void *) self);
    CGLContextObj context = [[self openGLContext] CGLContextObj];
    CGLPixelFormatObj format = [[self pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, context, format);
    CVDisplayLinkStart(displayLink);
}

- (void)dealloc
{
    CVDisplayLinkStop(displayLink);
    CVDisplayLinkRelease(displayLink);
}

@end
