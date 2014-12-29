AC_PREREQ([2.69])

if test -f version.txt ; then
  VERSION=`cat version.txt`
else
  VERSION=`git describe`
fi

AC_INIT([libreboot], $VERSION, [info@gluglug.org.uk])

dnl TODO: wait until the end to exit with an error?

dnl My goal with this file is to check for all of the dependencies
dnl that aren't in 'base-devel' on Parabola, or 'build-essential' on
dnl Trisquel 7.

AC_CHECK_PROG(HAVE_SVN,svn,yes)
if test "x$HAVE_SVN" = x ; then
  AC_MSG_ERROR([Please install the 'svn' utility])
fi

AC_CHECK_PROG(HAVE_GIT,git,yes)
if test "x$HAVE_GIT" = x ; then
  AC_MSG_ERROR([Please install the 'git' utility])
fi

AC_CHECK_PROG(HAVE_WGET,wget,yes)
if test "x$HAVE_WGET" = x ; then
  AC_MSG_ERROR([Please install the 'wget' utility])
fi

dnl 'sh' does not nescessarily imply 'bash'
AC_CHECK_PROG(HAVE_BASH,bash,yes)
if test "x$HAVE_BASH" = x ; then
  AC_MSG_ERROR([Please install the 'bash' utility])
fi

dnl This is a weird Parabola one
AC_CHECK_PROG(HAVE_MAKEPKG,makepkg,yes)
if test "x$HAVE_MAKEPKG" = x ; then
  AC_MSG_ERROR([Please install the 'makepkg' utility])
fi

dnl I know that /bin/python => Python 3 works,
dnl I haven't verified that /bin/python => Python 2 works.
AC_CHECK_PROG(HAVE_PYTHON,python,yes)
if test "x$HAVE_PYTHON" = x ; then
  AC_MSG_ERROR([Please install the 'python' utility])
fi

AC_CHECK_PROG(HAVE_IASL,iasl,yes)
if test "x$HAVE_IASL" = x ; then
  AC_MSG_ERROR([Please install the 'iasl' utility, it is needed for SeaBIOS])
fi

dnl This check is from grub's configure.ac
AC_MSG_CHECKING([for unifont])
FONT_SOURCE=
for ext in pcf pcf.gz bdf bdf.gz ttf ttf.gz; do
  for dir in . /usr/src /usr/share/fonts/X11/misc /usr/share/fonts/unifont /usr/share/fonts/uni /usr/share/fonts/truetype/unifont /usr/share/fonts/misc; do
    if test -f "$dir/unifont.$ext"; then
      md5="$(md5sum "$dir/unifont.$ext"|awk '{ print $1; }')"
      # PCF and BDF from version 6.3 isn't hanled properly by libfreetype.
      if test "$md5" = 0a54834d2788c83886a3e1785a6a1e61 || test "$md5" = 28f2565c7a41d8d407e2551159385edb || test "$md5" = dae5e588461b3b92b87b6ffee734f936 || test "$md5" = 4a3d687aa5bb329ed05f4263a1016791 ; then
        continue
      fi
      FONT_SOURCE="$dir/unifont.$ext"
      break 2
    fi
  done
done
if test "x$FONT_SOURCE" = x ; then
  AC_MSG_RESULT([no])
fi
AC_MSG_RESULT([yes])

dnl This is at least needed by memtest
AC_LANG_PUSH([C])
AC_MSG_NOTICE([----------------------------------------------------------------------------])
AC_MSG_NOTICE([The next few tests are for 32-bit C, NOT necessarily the native architecture])
AC_MSG_NOTICE([----------------------------------------------------------------------------])
AC_MSG_NOTICE([If you have GCC, but these fail, look for a 'gcc-multilib' package])
CFLAGS='-march=i486 -m32'
AC_CHECK_HEADERS([stdint.h sys/io.h],,[AC_MSG_ERROR([Could not find libc headers])])
AC_LANG_POP([C])
