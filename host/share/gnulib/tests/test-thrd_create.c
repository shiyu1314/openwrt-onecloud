/* Test of thrd_create () macro.
   Copyright (C) 2011-2023 Free Software Foundation, Inc.

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

/* Written by Bruno Haible <bruno@clisp.org>, 2011.  */

#include <config.h>

#include <threads.h>

#include <stdio.h>
#include <string.h>

#include "macros.h"

static thrd_t main_thread_before;
static thrd_t main_thread_after;
static thrd_t worker_thread;

#define MAGIC 1266074729
static volatile int work_done;

static int
worker_thread_func (void *arg)
{
  work_done = 1;
  return MAGIC;
}

int
main ()
{
  main_thread_before = thrd_current ();

  if (thrd_create (&worker_thread, worker_thread_func, NULL) == thrd_success)
    {
      int ret;

      /* Check that thrd_current () has the same value before than after the
         first call to thrd_create ().  */
      main_thread_after = thrd_current ();
      ASSERT (memcmp (&main_thread_before, &main_thread_after,
                      sizeof (thrd_t))
              == 0);

      ASSERT (thrd_join (worker_thread, &ret) == thrd_success);

      /* Check the return value of the thread.  */
      ASSERT (ret == MAGIC);

      /* Check that worker_thread_func () has finished executing.  */
      ASSERT (work_done);

      return 0;
    }
  else
    {
      fputs ("thrd_create failed\n", stderr);
      return 1;
    }
}
