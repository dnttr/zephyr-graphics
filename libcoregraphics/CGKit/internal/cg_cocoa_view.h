//
//  cg_cocoa_view.h
//  libcoregraphics
//
//  Created by Damian Netter on 15/05/2025.
//

#include "OpenGL/gl3.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    
    const char *title;
    int x, y;
    int width, height;
    
} ns_button;

GLuint add_button(ns_button *button);

#ifdef __cplusplus
} // extern "C"
#endif
