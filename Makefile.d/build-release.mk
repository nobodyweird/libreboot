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

dist_utils = \
	bucts \
	flashrom_normal \
	flashrom_lenovobios_macronix \
	flashrom_lenovobios_sst \
	cbfstool \
	nvramtool
dist_files = \
	$(MAKEFILE_LIST) \
	configure configure.ac \
	tmp/.gitignore \
	powertop.trisquel6 \
	powertop.trisquel6.init \
	powertop.trisquel7 \
	powertop.trisquel7.init \
	deps-trisquel \
	flash_lenovobios_stage1 \
	flash_lenovobios_stage2 \
	flash_libreboot6 \
	flash_macbook21applebios \
	flash_x60_libreboot5
dist_dirs = docs bin resources

distdir: PHONY \
    $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/version.txt \
    $(addprefix $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/utils/$(arch)/,$(dist_utils)) \
    $(addprefix $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/,$(dist_files) $(dist_dirs))

$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/utils/$(arch)/bucts: src/bucts/bucts
	mkdir -p $(@D)
	cp $< $@
$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/utils/$(arch)/flashrom_%: src/flashrom/flashrom_%
	mkdir -p $(@D)
	cp $< $@
$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/utils/$(arch)/cbfstool: src/coreboot/util/cbfstool/cbfstool
	mkdir -p $(@D)
	cp $< $@
$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/utils/$(arch)/nvramtool: src/coreboot/util/nvramtool/nvramtool
	mkdir -p $(@D)
	cp $< $@
$(addprefix $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/,$(dist_files)): \
$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/%: %
	mkdir -p $(@D)
	cp $< $@
$(addprefix $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/,$(dist_dirs)): \
$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/%: %
	mkdir -p $(@D)
	cp -r $< $@

$(PACKAGE_TARNAME)-$(PACKAGE_VERSION)/version.txt: PHONY
	mkdir -p $(@D)
	echo $(VERSION) > $@
