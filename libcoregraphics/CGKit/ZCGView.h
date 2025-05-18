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

@property (nonatomic, copy) void (^onExitCallback)(void);
@property (nonatomic, copy) void (^onRenderCallback)(void);
@property (nonatomic, copy) void (^onReshapeCallback)(int width, int height);
@property (nonatomic, copy) void (^onInitCallback)(void);
@property (nonatomic, copy) void (^onUpdateCallback)(void);

@end
