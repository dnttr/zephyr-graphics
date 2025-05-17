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

        ZCGWindowDelegate *delegate = [[ZCGWindowDelegate alloc] init];
        
        _window.delegate = delegate;
        _isRunning = YES;

        if (handle) {
            if (handle->on_exit_callback) {
                _onExitCallback = ^{
                    handle->on_exit_callback();
                };
            }
            if (handle->on_loop_callback) {
                _onLoopCallback = ^{
                    handle->on_loop_callback();
                };
            }
        }
        
        if (_onLoopCallback) {
            self.glView.onLoopCallback = _onLoopCallback;
        }
        
        NSLog(@"X");
        
        [_window makeKeyAndOrderFront:nil];
        [NSApp activateIgnoringOtherApps:YES];
    }
    return self;
}

- (void)isGoingToClose:(NSNotification *)notification {
    _isRunning = NO;
    if (_onExitCallback) {
        _onExitCallback();
    }
}

- (void)resize:(int)width height:(int)height {
    NSRect frame = NSMakeRect(NSMinX(_window.frame), NSMinY(_window.frame), width, height);
    [_window setContentSize:NSMakeSize(width, height)];
    [_glView setFrame:frame];
}

- (void)close {
    [[NSApplication sharedApplication] terminate:nil];
    _isRunning = NO;
}

@end
