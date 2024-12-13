/* Test of set data type implementation.
   Copyright (C) 2006-2023 Free Software Foundation, Inc.
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

#include <config.h>

#include "gl_hash_set.h"

#include <stdlib.h>
#include <string.h>

#include "gl_array_set.h"
#include "xalloc.h"
#include "macros.h"

static const char *objects[30] =
  {
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
    "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "<", ">", "[", "]"
  };

#define RANDOM(n) (rand () % (n))
#define RANDOM_OBJECT() objects[RANDOM (SIZEOF (objects))]

static int
cmp_objects_in_array (const void *objptr1, const void *objptr2)
{
  const void *obj1 = *(const void * const *)objptr1;
  const void *obj2 = *(const void * const *)objptr2;
  return strcmp ((const char *) obj1, (const char *) obj2);
}

static void
check_equals (gl_set_t set1, gl_set_t set2)
{
  size_t n = gl_set_size (set1);
  const void **elements_of_set1 = XNMALLOC (n, const void *);
  const void **elements_of_set2 = XNMALLOC (n, const void *);

  gl_set_iterator_t iter1;
  gl_set_iterator_t iter2;
  const void *elt1;
  const void *elt2;
  size_t i;

  iter1 = gl_set_iterator (set1);
  iter2 = gl_set_iterator (set2);
  for (i = 0; i < n; i++)
    {
      ASSERT (gl_set_iterator_next (&iter1, &elt1));
      ASSERT (gl_set_iterator_next (&iter2, &elt2));
      elements_of_set1[i] = elt1;
      elements_of_set2[i] = elt2;
    }
  ASSERT (!gl_set_iterator_next (&iter1, &elt1));
  ASSERT (!gl_set_iterator_next (&iter2, &elt2));
  gl_set_iterator_free (&iter1);
  gl_set_iterator_free (&iter2);

  if (n > 0)
    {
      qsort (elements_of_set1, n, sizeof (const void *), cmp_objects_in_array);
      qsort (elements_of_set2, n, sizeof (const void *), cmp_objects_in_array);
    }
  for (i = 0; i < n; i++)
    ASSERT (elements_of_set1[i] == elements_of_set2[i]);
  free (elements_of_set2);
  free (elements_of_set1);
}

static void
check_all (gl_set_t set1, gl_set_t set2)
{
  check_equals (set1, set2);
}

static bool
string_equals (const void *elt1, const void *elt2)
{
  return strcmp ((const char *) elt1, (const char *) elt2) == 0;
}

static size_t
string_hashcode (const void *elt)
{
  size_t hashcode = 0;
  const char *s;
  for (s = (const char *) elt; *s != '\0'; s++)
    hashcode += (unsigned char) *s;
  return hashcode;
}

int
main (int argc, char *argv[])
{
  gl_set_t set1, set2;

  /* Allow the user to provide a non-default random seed on the command line.  */
  if (argc > 1)
    srand (atoi (argv[1]));

  {
    size_t initial_size = RANDOM (20);
    size_t i;
    unsigned int repeat;

    /* Create set1.  */
    set1 = gl_set_nx_create_empty (GL_ARRAY_SET, string_equals, string_hashcode, NULL);
    ASSERT (set1 != NULL);

    /* Create set2.  */
    set2 = gl_set_nx_create_empty (GL_HASH_SET, string_equals, string_hashcode, NULL);
    ASSERT (set2 != NULL);

    check_all (set1, set2);

    /* Initialize them.  */
    for (i = 0; i < initial_size; i++)
      {
        const char *obj = RANDOM_OBJECT ();
        ASSERT (gl_set_nx_add (set1, obj) == gl_set_nx_add (set2, obj));
        check_all (set1, set2);
      }

    for (repeat = 0; repeat < 100000; repeat++)
      {
        unsigned int operation = RANDOM (3);
        switch (operation)
          {
          case 0:
            {
              const char *obj = RANDOM_OBJECT ();
              ASSERT (gl_set_search (set1, obj) == gl_set_search (set2, obj));
            }
            break;
          case 1:
            {
              const char *obj = RANDOM_OBJECT ();
              ASSERT (gl_set_nx_add (set1, obj) == gl_set_nx_add (set2, obj));
            }
            break;
          case 2:
            {
              const char *obj = RANDOM_OBJECT ();
              ASSERT (gl_set_remove (set1, obj) == gl_set_remove (set2, obj));
            }
            break;
          }
        check_all (set1, set2);
      }

    gl_set_free (set1);
    gl_set_free (set2);
  }

  return 0;
}
