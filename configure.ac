dnl My goal with this file is to check for all of the dependencies
dnl that aren't in 'base-devel' on Parabola, or 'build-essential' on
dnl Trisquel 7.

AC_PREREQ([2.69])

if test -f version.txt ; then
  PACKAGE_VERSION=`cat version.txt`
else
  PACKAGE_VERSION=`git describe`
fi

AC_INIT([libreboot], ${PACKAGE_VERSION}, [info@gluglug.org.uk], [], [http://libreboot.org/])
m4_include(m4/ax_check_compile_flag.m4)
m4_include(m4/ax_check_link_flag.m4)

missing=''

dnl 'sh' does not nescessarily imply 'bash'
AC_CHECK_PROG(HAVE_BASH,bash,yes)
test "x$HAVE_BASH" = xyes || missing="$missing bash"

AC_CHECK_PROG(HAVE_BSDTAR,bsdtar,yes)
test "x$HAVE_BSDTAR" = xyes || missing="$missing bsdtar"

AC_CHECK_PROG(HAVE_GIT,git,yes)
test "x$HAVE_GIT" = xyes || missing="$missing git"

AC_CHECK_PROG(HAVE_IASL,iasl,yes)
test "x$HAVE_IASL" = xyes || missing="$missing iasl"

dnl I know that /bin/python => Python 3 works,
dnl I haven't verified that /bin/python => Python 2 works.
dnl (needed for grub's build)
AC_CHECK_PROG(HAVE_PYTHON,python,yes)
test "x$HAVE_PYTHON" = xyes || missing="$missing python"

AC_CHECK_PROG(HAVE_SVN,svn,yes)
test "x$HAVE_SVN" = xyes || missing="$missing svn"

AC_CHECK_PROG(HAVE_WGET,wget,yes)
test "x$HAVE_WGET" = xyes || missing="$missing wget"

if test "x$missing" != x ; then
  AC_MSG_ERROR([The following needed programs were not found:$missing])
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

dnl This test is based on memtest86+
AC_LANG_PUSH([C])
AX_CHECK_COMPILE_FLAG([-march=i486 -m32], [], [AC_MSG_ERROR([Cannot compile for 32-bit])], [], [AC_LANG_SOURCE
#include <stdint.h>
#include <sys/io.h>
])

MAINTAINER_MODE=y
AC_SUBST(MAINTAINER_MODE)

dnl This check is from flashrom's Makefile
AX_CHECK_LINK_FLAG([-static -m64], [],
  [
   if test "x$MAINTAINER_MODE" != x ; then
     AC_MSG_NOTICE([Cannot compile statically for 64-bit; disabling maintainer mode])
     MAINTAINER_MODE=
   fi
  ],
  [-lz -lpci],
  [AC_LANG_SOURCE
 #define index shadow_workaround_index
#if !defined __NetBSD__ && !defined __DragonFly__
#include <pci/pci.h>
#else
#include <pciutils/pci.h>
#endif
struct pci_access *pacc;
int main(int argc, char **argv)
{
	(void) argc;
	(void) argv;
	pacc = pci_alloc();
	return 0;
}
])

dnl This check is from flashrom's Makefile
AX_CHECK_LINK_FLAG([-static -m32], [],
  [
   if test "x$MAINTAINER_MODE" != x ; then
     AC_MSG_NOTICE([Cannot compile statically for 32-bit; disabling maintainer mode])
     MAINTAINER_MODE=
   fi
  ],
  [-lz -lpci],
  [AC_LANG_SOURCE
#define index shadow_workaround_index
#if !defined __NetBSD__ && !defined __DragonFly__
#include <pci/pci.h>
#else
#include <pciutils/pci.h>
#endif
struct pci_access *pacc;
int main(int argc, char **argv)
{
	(void) argc;
	(void) argv;
	pacc = pci_alloc();
	return 0;
}
])
AC_LANG_POP([C])

AC_CONFIG_FILES([config.mk])
AC_OUTPUT
