//
//  CGWindowDelegate.h
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Cocoa/Cocoa.h>

@interface ZCGWindowDelegate : NSObject <NSWindowDelegate>
@property (nonatomic, copy) void (^onClose)(void);
@end
