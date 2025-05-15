//
//  core_graphics.mm
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import "core_graphics.h"

#import "ZCGWindow.h"
#import "ZCGAppController.h"

static ZCGWindow *globalWindow = nil;
static ZCGAppController *appController = nil;

zcg_window_t *cg_allocate(zcg_window_args_t *args, zcg_callback_handle *handle) {
    @autoreleasepool {
        NSString *title = [NSString stringWithUTF8String:args->title];

        globalWindow = [[ZCGWindow alloc] initWithTitle:title
                                                     x:args->x
                                                     y:args->y
                                                 width:args->width
                                                height:args->height];

        if (handle && handle->on_exit_callback) {
            [globalWindow setOnClose:^{
                handle->on_exit_callback();
            }];
        }

        appController = [[ZCGAppController alloc] init];
        [appController startWithWindow:globalWindow];

        zcg_window_t *win = (zcg_window_t *)calloc(1, sizeof(zcg_window_t));

        win->loop = []() -> bool {
            return true;
        };

        win->exit = []() {
            [NSApp terminate:nil];
        };

        win->resize = [](int width, int height) {
            NSRect frame = [globalWindow.nsWindow frame];
            frame.size.width = width;
            frame.size.height = height;
            [globalWindow.nsWindow setFrame:frame display:YES];
        };

        return win;
    }
}

