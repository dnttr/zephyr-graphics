//
//  CGAppController.m
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Foundation/Foundation.h>

#import "ZCGAppController.h"
#import "ZCGWindow.h"

@implementation ZCGAppController

- (void)startWithWindow:(ZCGWindow *)window {
    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp run];
}

@end
