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

flashrom_source = svn://flashrom.org/flashrom/trunk\#revision=1854

flashrom_patches = $(wildcard resources/flashrom/patch/flashchips_*.c)
define flashrom_patch
	cp resources/flashrom/patch/flashchips_*.c $@
	sed -i \
	    -e 's/\$$(PROGRAM)\$$(EXEC_SUFFIX)/$$(PROGRAM)$$(patchname)$$(EXEC_SUFFIX)/g' \
	    -e 's/flashchips\.o/flashchips$$(patchname).o/g' \
	    -e 's/libflashrom\.a/libflashrom$$(patchname).a/g' \
	    -e 's/\(rm .*libflashrom\)\S*\.a/\1*.a $$(PROGRAM)_*/' \
	    $@/Makefile
endef

$(foreach arch,$(arches),tmp/builddeps-stamps/$(arch)/flashrom): \
tmp/builddeps-stamps/%/flashrom: src/%/flashrom
	$(MAKE) CC='$(CC)' -C $< patchname=_normal
	$(MAKE) CC='$(CC)' -C $< patchname=_lenovobios_macronix
	$(MAKE) CC='$(CC)' -C $< patchname=_lenovobios_sst
	mkdir -p $(@D)
	touch $@
