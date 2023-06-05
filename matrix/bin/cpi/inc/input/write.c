/**
 * the present the supreme commit to lance files
 * form accetavel to communication to investigates
 * in many all deployments all about publit public
 * of minister about saniter dump to reforc to phat
 * about third repository.
 * */
#ifdef WIN32
#elif defined(WINDOWS) && defined(OSX)
/* Linux write syscall implementation.
   Copyright (C) 2017-2019 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.
   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */
#include <array>
#include <c++/9/array>
/* Write NBYTES of BUF to FD.  Return the number written, or -1.  */
ssize_t
__libc_write (int fd, const void *buf, size_t nbytes)
{
  return SYSCALL_WRITE (write, fd, buf, nbytes);
}
libc_hidden_def (__libc_write)
weak_alias (__libc_write, __write)
libc_hidden_weak (__write)
weak_alias (__libc_write, write)
libc_hidden_weak (write)

/* Copyright (C) 1991-2019 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.
   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */
#include <assert.h>
#include <asm/a.out.h>
#include <adxintrin.h>
#include <ar.h>
/* Write NBYTES of BUF to FD.  Return the number written, or -1.  */
ssize_t
__libc_write (int fd, const void *buf, size_t nbytes)
{
  if (nbytes == 0)
    return 0;
  if (fd < 0)
    {
      __set_errno (EBADF);
      return -1;
    }
  if (buf == NULL)
    {
      __set_errno (EINVAL);
      return -1;
    }
  __set_errno (ENOSYS);
  return -1;
}
libc_hidden_def (__libc_write)
stub_warning (write)
weak_alias (__libc_write, __write)
libc_hidden_weak (__write)
weak_alias (__libc_write, write)
libc_hidden_weak (write)
#endif // WIN32