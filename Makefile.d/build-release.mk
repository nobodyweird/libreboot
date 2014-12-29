
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
    libreboot-$(VERSION)/version.txt \
    $(addprefix libreboot-$(VERSION)/utils/$(arch)/,$(dist_utils)) \
    $(addprefix libreboot-$(VERSION)/,$(dist_files) $(dist_dirs))

libreboot-$(VERSION)/utils/$(arch)/bucts: src/bucts/bucts
	mkdir -p $(@D)
	cp $< $@
libreboot-$(VERSION)/utils/$(arch)/flashrom_%: src/flashrom/flashrom_%
	mkdir -p $(@D)
	cp $< $@
libreboot-$(VERSION)/utils/$(arch)/cbfstool: src/coreboot/util/cbfstool/cbfstool
	mkdir -p $(@D)
	cp $< $@
libreboot-$(VERSION)/utils/$(arch)/nvramtool: src/coreboot/util/nvramtool/nvramtool
	mkdir -p $(@D)
	cp $< $@
$(addprefix libreboot-$(VERSION)/,$(dist_files)): \
libreboot-$(VERSION)/%: %
	mkdir -p $(@D)
	cp $< $@
$(addprefix libreboot-$(VERSION)/,$(dist_dirs)): \
libreboot-$(VERSION)/%: %
	mkdir -p $(@D)
	cp -r $< $@

libreboot-$(VERSION)/version.txt: PHONY
	mkdir -p $(@D)
	echo $(VERSION) > $@
