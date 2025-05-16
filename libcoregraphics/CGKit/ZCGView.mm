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

static CVReturn callback(CVDisplayLinkRef displayLink,
                         const CVTimeStamp *inNow,
                         const CVTimeStamp *inOutputTime,
                         CVOptionFlags flagsIn,
                         CVOptionFlags *flagsOut,
                         void *displayLinkContext) {
    @autoreleasepool {
        ZCGView *view = (__bridge ZCGView *)displayLinkContext;
        [view draw];
    }
    
    return kCVReturnSuccess;
}

- (void)prepareOpenGL {
    [super prepareOpenGL];
    [[self openGLContext] makeCurrentContext];
        
    GLint sync = 1;
    [[self openGLContext] setValues:&sync forParameter:NSOpenGLCPSwapInterval];
}

- (void)reshape {
    [super reshape];

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
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self openGLContext] makeCurrentContext];
            
        if (self->_onLoopCallback) {
            self->_onLoopCallback();
        }
        
        [[self openGLContext] flushBuffer];
    });
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
