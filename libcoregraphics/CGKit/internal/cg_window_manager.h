//
//  cg_window_manager.h
//  libcoregraphics
//
//  Created by Damian Netter on 14/05/2025.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef struct cg_renderer_t *cg_renderer;
    
    typedef struct
    {
        const char *title;

        int x, y;

        int width, height;
    } zcg_window_args_t;

    typedef struct
    {
        cg_renderer (*create)(void);
        
        void (*exit)(void);

        void (*resize)(int width, int height);

        void (*initialize)(cg_renderer, int width, int height);
    } zcg_window_t;

    typedef struct
    {
        void (*on_exit_callback)(void);
        
        void (*on_loop_callback)(void);

        void (*on_reshape_callback)(int width, int height);
    } zcg_callback_handle;
    
    zcg_window_t *cg_allocate(zcg_window_args_t *args, zcg_callback_handle *handle);

    void cg_run(const zcg_window_t *window);

#ifdef __cplusplus
} // extern "C"
#endif
