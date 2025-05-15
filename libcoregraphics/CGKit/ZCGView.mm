//
//  ZCGView.m
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Foundation/Foundation.h>
#import "AppKit/AppKit.h"

#import "internal/cg_window_manager.h"

#import "ZCGView.h"

@implementation ZCGView

- (void)prepareOpenGL {
    [super prepareOpenGL];
    [[self openGLContext] makeCurrentContext];
    
    //INVOKE C++ SIDE
    
    GLint sync = 1;
    [[self openGLContext] setValues:&sync forParameter:NSOpenGLCPSwapInterval];
}

- (void)reshape {
    [super reshape];
    
// INVOKE C++ SIDE
}

- (void)drawRect:(NSRect)dirtyRect {
    [[self openGLContext] makeCurrentContext];
    
    NSRect rect = [self convertRectToBacking:self.bounds];
    
    //INVOKE C++ SIDE
    
    [[self openGLContext] flushBuffer];
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
        [[self openGLContext] makeCurrentContext];
    }
    
    return self;
}

- (void)runLoopOnce {
    [self setNeedsDisplay:true];
}

@end
