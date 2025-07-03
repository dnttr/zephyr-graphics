//
//  ZCGView.h
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CVDisplayLink.h>

@interface ZCGView : NSOpenGLView
{
    CVDisplayLinkRef displayLink;
}

@property (nonatomic, assign) zcg_callback_handle *callbackHandle;

@property (nonatomic, copy) void (^onExitCallback)(void);
@property (nonatomic, copy) void (^onRenderCallback)(void);
@property (nonatomic, copy) void (^onReshapeCallback)(int width, int height);
@property (nonatomic, copy) void (^onInitCallback)(void);
@property (nonatomic, copy) void (^onUpdateCallback)(void);
@property (nonatomic, copy) void (^onScrollCallback)(CGFloat deltaX, CGFloat deltaY, NSPoint mouseLocation);
@property (nonatomic, copy) void (^onMouseMoveCallback)(NSPoint mouseLocation);
@property (nonatomic, copy) void (^onMouseEnterCallback)(NSPoint mouseLocation);
@property (nonatomic, copy) void (^onMouseExitCallback)(NSPoint mouseLocation);

@end
