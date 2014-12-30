
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
