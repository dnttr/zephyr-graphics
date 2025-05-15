//
//  ZCGView.h
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Cocoa/Cocoa.h>

@interface ZCGView : NSOpenGLView

@property (nonatomic, copy) void (^onExitCallback)(void);

- (void)runLoopOnce;

@end
