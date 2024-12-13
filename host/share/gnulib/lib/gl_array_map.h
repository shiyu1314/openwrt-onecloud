/* Map data type implemented by an array.
   Copyright (C) 2006, 2009-2023 Free Software Foundation, Inc.
   Written by Bruno Haible <bruno@clisp.org>, 2018.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

#ifndef _GL_ARRAY_MAP_H
#define _GL_ARRAY_MAP_H

#include "gl_map.h"

#ifdef __cplusplus
extern "C" {
#endif

extern const struct gl_map_implementation gl_array_map_implementation;
#define GL_ARRAY_MAP &gl_array_map_implementation

#ifdef __cplusplus
}
#endif

#endif /* _GL_ARRAY_MAP_H */
