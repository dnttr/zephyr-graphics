//
//  CGKeyEvent.h
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Cocoa/Cocoa.h>

@interface ZCGKeyEvent : NSView
- (void)setOnKeyPress:(void (^)(unsigned short keyCode))callback;
@end
