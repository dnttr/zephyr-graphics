//
//  cg_window_manager.h
//  libcoregraphics
//
//  Created by Damian Netter on 14/05/2025.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C"
{
#endif

#define ZCG_MOUSE_BUTTON_LEFT   0
#define ZCG_MOUSE_BUTTON_RIGHT  1
#define ZCG_MOUSE_BUTTON_MIDDLE 2

typedef struct
{
    const char *title;

    int x, y;

    int width, height;

    int min_width, min_height;
    int max_width, max_height;
} zcg_window_args_t;

typedef struct
{
    void (* exit)();

    void (* resize)(int width, int height);

    bool (* is_retina)();

    void (* get_mouse_position)(float *x, float *y);

    bool (* is_mouse_in_window)();
} zcg_window_t;

typedef struct
{
    float x, y;
} zcg_mouse_pos_t;

typedef struct
{
    float delta_x, delta_y;
    float mouse_x, mouse_y;

    bool is_precise;
} zcg_scroll_event_t;

typedef struct
{
    unsigned int key_code;

    bool is_pressed;
    bool shift, ctrl, alt, cmd;
} zcg_key_event_t;

typedef struct
{
    void (* on_exit_callback)(void);

    void (* on_render_callback)(void);

    void (* on_reshape_callback)(int width, int height);

    void (* on_init_callback)(void);

    void (* on_update_callback)(void);

    void (* on_mouse_move_callback)(zcg_mouse_pos_t mouse_pos);

    void (* on_mouse_enter_callback)(zcg_mouse_pos_t mouse_pos);

    void (* on_mouse_exit_callback)(zcg_mouse_pos_t mouse_pos);

    void (* on_mouse_down_callback)(zcg_mouse_pos_t mouse_pos, int button);

    void (* on_mouse_up_callback)(zcg_mouse_pos_t mouse_pos, int button);

    void (* on_scroll_callback)(zcg_scroll_event_t scroll_event);

    void (* on_key_down_callback)(zcg_key_event_t key_event);

    void (* on_key_up_callback)(zcg_key_event_t key_event);
} zcg_callback_handle;

zcg_window_t *zcg_allocate(zcg_window_args_t *args, zcg_callback_handle *handle);

void zcg_run(const zcg_window_t *window);

#ifdef __cplusplus
} // extern "C"
#endif
