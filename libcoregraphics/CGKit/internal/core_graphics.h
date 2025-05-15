//
//  libcoregraphics.h
//  libcoregraphics
//
//  Created by Damian Netter on 14/05/2025.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef struct
    {
        const char *title;

        int x, y;

        int width, height;
    } zcg_window_args_t;

    typedef struct
    {
        void (*exit)(void);

        void (*resize)(int width, int height);

        bool (*loop)(void);
    } zcg_window_t;

    typedef struct
    {
        void (*on_exit_callback)(void);
    } zcg_callback_handle;

    zcg_window_t *cg_allocate(zcg_window_args_t *args, zcg_callback_handle *handle);


#ifdef __cplusplus
} // extern "C"
#endif
