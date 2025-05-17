//
//  ZCGWindow.h
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Cocoa/Cocoa.h>

#import "internal/cg_window_manager.h"

#import "ZCGView.h"

@interface ZCGWindow : NSObject

@property (nonatomic, strong, readonly) NSWindow *nsWindow;

@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) ZCGView *glView;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, copy) void (^onExitCallback)(void);


- (instancetype)initWithTitle:(const char *)title
                            x:(int)x
                            y:(int)y
                        width:(int)width
                       height:(int)height
               callbackHandle:(zcg_callback_handle *)handle;

- (void)resize:(int)width height:(int)height;
- (void)close;

@end
