//
//  ZCGWindowDelegate.m
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Foundation/Foundation.h>
#import "ZCGWindowDelegate.h"

@implementation ZCGWindowDelegate

- (void) windowWillClose:(NSNotification *)notification {    
    if (self.onClose) {
        self.onClose();
    }
}

@end

