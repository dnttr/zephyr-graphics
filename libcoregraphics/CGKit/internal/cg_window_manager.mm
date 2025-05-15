//
//  core_graphics.mm
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import "cg_interface.h.h"

#import "ZCGWindow.h"

static ZCGWindow *globalWindow = nil;

static void cg_exit(void) {
    if (globalWindow) {
        [globalWindow closeWindow];
        globalWindow = nil;
    }
}

static void cg_resize(int width, int height) {
    if (globalWindow) {
        [globalWindow resizeToWidth:width height:height];
    }
}

static bool cg_loop(void) {
    if (!globalWindow) return false;
    if (!globalWindow.isRunning) return false;

    [globalWindow runLoopOnce];
    return globalWindow.isRunning;
}

zcg_window_t *cg_allocate(zcg_window_args_t *args, zcg_callback_handle *handle) {
    if (globalWindow) {
        return NULL; // Only one window for now
    }

    globalWindow = [[ZCGWindow alloc] initWithTitle:args->title
                                                x:args->x
                                                y:args->y
                                            width:args->width
                                           height:args->height
                                   callbackHandle:handle];
    if (!globalWindow) return NULL;

    static zcg_window_t windowApi;
    windowApi.exit = cg_exit;
    windowApi.resize = cg_resize;
    windowApi.loop = cg_loop;

    return &windowApi;
}
