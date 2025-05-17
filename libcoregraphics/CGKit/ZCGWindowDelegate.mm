//
//  ZCGWindowDelegate.mm
//  libcoregraphics
//
//  Created by Damian Netter on 17/05/2025.
//

#import <Foundation/Foundation.h>
#import "ZCGWindowDelegate.h"

@implementation ZCGWindowDelegate

- (BOOL)windowShouldClose:(NSWindow *)sender {
    [NSApp terminate:nil];
    return NO;
}

@end
