//
//  key_handler.m
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import <Foundation/Foundation.h>
#import "AppKit/AppKit.h"

#import "internal/core_graphics.h"

#import "ZCGView.h"

@interface ZCGView ()
@property (nonatomic, copy) void (^keyPressCallback)(unsigned short);
@end

@implementation ZCGView

- (void)prepareOpenGL {
    [super prepareOpenGL];
}

- (void)reshape {
    [super reshape];
}



- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)keyDown:(NSEvent *)event {
    if (self.keyPressCallback) {
        self.keyPressCallback(event.keyCode);
    }
}

- (void)setOnKeyPress:(void (^)(unsigned short))callback {
    self.keyPressCallback = callback;
}

@end
