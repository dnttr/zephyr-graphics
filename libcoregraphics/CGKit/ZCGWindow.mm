//
//  ZCGWindow.mm
//  libcoregraphics
//
//  Created by Damian Netter on 14/05/2025.
//

#import "OpenGL/OpenGL.h"

#import "internal/cg_window_manager.h"

#import "ZCGWindowDelegate.h"
#import "ZCGWindow.h"

@implementation ZCGWindow

- (instancetype)initWithTitle:(const char *)title
                            x:(int)x
                            y:(int)y
                        width:(int)width
                       height:(int)height
               callbackHandle:(zcg_callback_handle *)handle
{
    self = [super init];
    if (self) {
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

        NSRect frame = NSMakeRect(x, y, width, height);
        _window = [[NSWindow alloc] initWithContentRect:frame
                                              styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable)
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
        NSString *titleStr = [NSString stringWithUTF8String:title];
        [_window setTitle:titleStr];

        _glView = [[ZCGView alloc] initWithFrame:frame];
        [_window setContentView:_glView];

        _window.delegate = self;
        _isRunning = YES;

        if (handle && handle->on_exit_callback) {
            _onExitCallback = ^{
                handle->on_exit_callback();
            };
        }

        [_window makeKeyAndOrderFront:nil];
        [NSApp activateIgnoringOtherApps:YES];
    }
    return self;
}

- (void)windowWillClose:(NSNotification *)notification {
    _isRunning = NO;
    if (_onExitCallback) {
        _onExitCallback();
    }
}

- (void)runLoopOnce {
    NSEvent *event;
    while ((event = [NSApp nextEventMatchingMask:NSEventMaskAny
                                       untilDate:[NSDate distantPast]
                                          inMode:NSDefaultRunLoopMode
                                         dequeue:YES])) {
        [NSApp sendEvent:event];
    }

    [_glView runLoopOnce];
}

- (void)resizeToWidth:(int)width height:(int)height {
    NSRect frame = NSMakeRect(NSMinX(_window.frame), NSMinY(_window.frame), width, height);
    [_window setContentSize:NSMakeSize(width, height)];
    [_glView setFrame:frame];
}

- (void)closeWindow {
    [_window close];
    _isRunning = NO;
}

@end
