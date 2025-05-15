//
//  libcoregraphics.m
//  libcoregraphics
//
//  Created by Damian Netter on 14/05/2025.
//

#import "OpenGL/OpenGL.h"

#import "internal/core_graphics.h"

#import "ZCGWindow.h"
#import "ZCGWindowDelegate.h"

#import "ZCGView.h"

@interface ZCGWindow ()
@property (nonatomic, strong) ZCGWindowDelegate *delegate;
@end

@implementation ZCGWindow

- (instancetype)initWithTitle:(NSString *)title x:(int)x y:(int)y width:(int)width height:(int)height {
    if (self = [super init]) {
        NSRect frame = NSMakeRect(x, y, width, height);
        _nsWindow = [[NSWindow alloc] initWithContentRect:frame
                                                 styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable)
                                                   backing:NSBackingStoreBuffered
                                                     defer:NO];
        [_nsWindow setTitle:title];

        ZCGKeyEvent *view = [[ZCGKeyEvent alloc] initWithFrame:frame];
        [_nsWindow setContentView:view];
        [_nsWindow setInitialFirstResponder:view];

        _delegate = [[ZCGWindowDelegate alloc] init];
        [_nsWindow setDelegate:_delegate];

        [_nsWindow makeKeyAndOrderFront:nil];

        // OpenGL setup, deprecated
       
        [glContext makeCurrentContext];
    }
    return self;
}

- (void)setOnClose:(ZCGWindowCloseCallback)callback {
    self.delegate.onClose = callback;
}

- (void)setOnKeyPress:(ZCGKeyPressCallback)callback {
    NSView *view = self.nsWindow.contentView;
    if ([view isKindOfClass:[ZCGKeyEvent class]]) {
        [(ZCGKeyEvent *)view setOnKeyPress:callback];
    }
}

@end
