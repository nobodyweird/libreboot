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

grubinvaders_source = http://www.erikyyy.de/invaders/invaders-1.0.0.tar.gz

grubinvaders_patches = resources/grubinvaders/patch/diff.patch resources/grubinvaders/patch/compile.sh.patch
define grubinvaders_patch
	# Apply patch mentioned on http://www.coreboot.org/GRUB_invaders
	cd $@ && patch < $(abspath resources/grubinvaders/patch/diff.patch)
	cd $@ && patch compile.sh < $(abspath resources/grubinvaders/patch/compile.sh.patch)
endef

$(foreach arch,$(arches),tmp/builddeps-stamps/$(arch)/grubinvaders): \
tmp/builddeps-stamps/%/grubinvaders: src/%/grubinvaders
	cd $< && ./compile.sh
	mkdir -p $(@D)
	touch $@
cleandeps-%/grubinvaders-custom: PHONY
	test ! -d src/%/grubinvaders || { cd src/%/grubinvaders && ./clean.sh; }
