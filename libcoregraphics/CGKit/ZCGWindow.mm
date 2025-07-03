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
                       min_width:(int)min_width
                       min_height:(int)min_height
                       max_width:(int)max_width
                       max_height:(int)max_height
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

        [_window setMinSize:NSMakeSize(min_width, min_height)];
       // [_window setMaxSize:NSMakeSize(max_width, max_height)];
        [_window setContentAspectRatio:NSMakeSize(width, height)];
        
        ZCGWindowDelegate *delegate = [[ZCGWindowDelegate alloc] init];
        
        if (handle->on_render_callback) {
            self.glView.onRenderCallback = ^{
                handle->on_render_callback();
            };
        }
        if (handle->on_reshape_callback) {
            self.glView.onReshapeCallback = ^(int width, int height){
                handle->on_reshape_callback(width, height);
            };
        }
        if (handle->on_init_callback) {
            self.glView.onInitCallback = ^{
                handle->on_init_callback();
            };
        }
        if (handle->on_update_callback) {
            self.glView.onUpdateCallback = ^{
                handle->on_update_callback();
            };
        }

        [self.glView setCallbackHandle:handle]; //TODO: move it to this class, its only temporary in there.
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillTerminateNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
            if (handle->on_exit_callback) {
                handle->on_exit_callback();
            }
        }];
        
        _window.delegate = delegate;
        _isRunning = YES;
                
        [_window makeKeyAndOrderFront:nil];
        [NSApp activateIgnoringOtherApps:YES];
    }
    return self;
}

- (void)resize:(int)width height:(int)height {
    NSRect frame = NSMakeRect(NSMinX(_window.frame), NSMinY(_window.frame), width, height);
    [_window setContentSize:NSMakeSize(width, height)];
    [_glView setFrame:frame];
}

- (bool)isRetina {
    NSScreen *screen = [_window screen];
    CGFloat scale = screen.backingScaleFactor;
    return scale > 1.0;
}

@end
