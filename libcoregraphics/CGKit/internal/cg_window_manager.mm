//
//  core_graphics.mm
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#import "cg_window_manager.h"

#import "ZCGWindow.h"

static ZCGWindow *globalWindow = nil;

static void zcg_exit(void) {
    if (globalWindow) {
        //[globalWindow close];
        globalWindow = nil;
    }
}

static void zcg_resize(int width, int height) {
    if (globalWindow) {
        [globalWindow resize:width height:height];
    }
}

static bool zcg_is_retina(void) {
    if (globalWindow) {
        return [globalWindow isRetina];
    }
    
    return false;
}

zcg_window_t *zcg_allocate(zcg_window_args_t *args, zcg_callback_handle *handle) {
    if (globalWindow) {
        return NULL; // Only one window for now
    }
    
    if (handle == nullptr) {
        return NULL;
    }

    globalWindow = [[ZCGWindow alloc] initWithTitle:args->title
                                                x:args->x
                                                y:args->y
                                            width:args->width
                                           height:args->height
                                           min_width:args->min_width
                                           min_height:args->min_height
                                          max_width:args->max_width
                                         max_height:args->max_height
                                     callbackHandle:handle];
    
    if (!globalWindow) return NULL;

    static zcg_window_t windowApi;
    windowApi.exit = zcg_exit;
    windowApi.resize = zcg_resize;
    windowApi.is_retina = &zcg_is_retina;

    return &windowApi;
}

void zcg_run(const zcg_window_t *window) {
    [NSApp run];
}
