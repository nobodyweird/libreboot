modules = \
	coreboot \
	grub \
	memtest86 \
	bucts \
	flashrom \
	seabios \
	grubinvaders \
	dejavu \
	i945pwm
# powertop only needs to be used when running './powertop.trisquel6'
all_modules = $(modules) powertop

# Easy names for src/% and tmp/builddeps-%.stamp
$(addprefix get,$(all_modules)): get%: PHONY src/%
$(addprefix builddeps-,$(all_modules)): builddeps-%: PHONY tmp/builddeps-%.stamp

# The "all" rules
getall: $(addprefix src/,$(modules))
builddeps: $(addprefix builddeps-,$(modules))
cleandeps: $(addprefix cleandeps-,$(all_modules))
	rm -rf bin/* tmp/*

# If we depend on a file in src/*/*, we should generate it by calling
# the builddep rule.
$(foreach module,$(all_modules),$(eval src/$(module)/%: | tmp/builddeps-$(module).stamp; test -e $$@))


# The generic rules

# "get" rules
$(addprefix src/,$(all_modules)): \
src/%: get source-locations.sh
	./get $*
	test -e $@
	touch $@

# "builddeps" rules
tmp/builddeps-%.stamp: src/%
	$(MAKE) -C $<
	touch $@

# "cleandeps" rules
$(addprefix cleandeps-,$(all_modules)): \
cleandeps-%: PHONY cleandeps-%-custom
	rm -f tmp/builddeps-%.stamp
cleandeps-%-custom: PHONY
	test ! -f src/$*/Makefile || $(MAKE) -C src/$* clean


# The overrides

$(addprefix src/coreboot/util/,cbfstool nvramtool crossgcc): \
src/coreboot/util/%: | src/coreboot
	test -d $@
tmp/builddeps-coreboot.stamp:: \
    tmp/builddeps-coreboot-cbfstool.stamp \
    tmp/builddeps-coreboot-nvramtool.stamp \
    tmp/builddeps-coreboot-crossgcc.stamp
	touch $@
tmp/builddeps-coreboot-cbfstool.stamp:: src/coreboot/util/cbfstool
	$(MAKE) -C $<
	touch $@
tmp/builddeps-coreboot-nvramtool.stamp:: src/coreboot/util/nvramtool
	$(MAKE) -C $<
	touch $@
tmp/builddeps-coreboot-crossgcc.stamp:: src/coreboot/util/crossgcc
	$(MAKE) -C src/coreboot crossgcc-i386
	touch $@
cleandeps-coreboot-custom:: PHONY
	test ! -f src/coreboot/Makefile || $(MAKE) -C src/coreboot clean
	test ! -f src/coreboot/Makefile || $(MAKE) -C src/coreboot/util/cbfstool clean
	test ! -f src/coreboot/Makefile || $(MAKE) -C src/coreboot/util/nvramtool clean
	test ! -f src/coreboot/Makefile || $(MAKE) -C src/coreboot crossgcc-clean
	rm -f tmp/builddeps-coreboot-*.stamp

tmp/builddeps-flashrom.stamp:: src/flashrom
	$(MAKE) -C $< patchname=_normal
	$(MAKE) -C $< patchname=_lenovobios_macronix
	$(MAKE) -C $< patchname=_lenovobios_sst
	touch $@

tmp/builddeps-grub.stamp:: src/grub
	cd $< && { test -x ./configure || ./autogen.sh; }
	cd $< && { test -f ./Makefile || ./configure --with-platform=coreboot; }
	$(MAKE) -C $<
	touch $@

tmp/builddeps-powertop.stamp:: src/powertop
	cd $< && { text -x ./configure || ./autogen.sh; }
	cd $< && { test -f ./Makefile || ./configure; }
	$(MAKE) -C $<
	touch $@

tmp/builddeps-grubinvaders.stamp:: src/grubinvaders
	cd $< && ./compile.sh
	touch $@
cleandeps-grubinvaders-custom:: PHONY
	test ! -d src/grubinvaders || { cd src/grubinvaders && ./clean.sh; }

tmp/builddeps-seabios.stamp:: src/seabios resources/seabios/config/config
	cp resources/seabios/config/config $</.config
	$(MAKE) -C $<
	touch $@

tmp/builddeps-dejavu.stamp:: src/dejavu ; touch $@
cleandeps-dejavu-custom:: PHONY ;

cleandeps-i945pwm-custom:: PHONY
	rm -f src/i945pwm/i945-pwm
