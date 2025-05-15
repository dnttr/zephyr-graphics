//
//  CGWindow.h
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Cocoa/Cocoa.h>

typedef void (^ZCGWindowCloseCallback)(void);
typedef void (^ZCGKeyPressCallback)(unsigned short keyCode);

@interface ZCGWindow : NSObject

@property (nonatomic, strong, readonly) NSWindow *nsWindow;

- (instancetype) initWithTitle:(NSString *)title
                             x:(int)x
                             y:(int)y
                         width:(int)width
                        height:(int)height;

- (void)setOnClose:(ZCGWindowCloseCallback)callback;
- (void)setOnKeyPress:(ZCGKeyPressCallback)callback;

@end
