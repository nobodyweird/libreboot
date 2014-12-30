#
#	Copyright (C) 2014 Francis Rowe <info@gluglug.org.uk>
#	Copyright (C) 2014 Luke Shumaker <lukeshu@sbcglobal.net>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

grub_source = git://git.savannah.gnu.org/grub.git\#commit=e2dd6daa8c33e3e7641e442dc269fcca479c6fda

grub_patches = resources/grub/patch/gitdiff
define grub_patch
	cd $@ && git apply $(abspath resources/grub/patch/gitdiff)
endef

grub_configure = --with-platform=coreboot
