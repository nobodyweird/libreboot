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

getall: $(addprefix src/,$(modules))
builddeps: $(addprefix builddeps-,$(modules))
cleandeps: $(addprefix cleandeps-,$(all_modules))
	rm -rf bin/*

# The generic rules

$(foreach module,$(all_modules),$(eval src/$(module)/%: builddeps-$(module); test -e $$@))

src/%: get source-locations.sh
	./get $*
builddeps-%: src/%
	$(MAKE) -C $<
cleandeps-%:
	test ! -f src/$*/Makefile || $(MAKE) -C src/$* clean

# The overrides

builddeps-coreboot:: src/coreboot
	$(MAKE) -C $</util/cbfstool
	$(MAKE) -C $</util/nvramtool
	$(MAKE) -C $< crossgcc-i386
cleandeps-coreboot::
	test ! -f src/coreboot/Makefile || $(MAKE) -C src/coreboot clean
	test ! -f src/coreboot/Makefile || $(MAKE) -C src/coreboot/util/cbfstool clean
	test ! -f src/coreboot/Makefile || $(MAKE) -C src/coreboot/util/nvramtool clean
	test ! -f src/coreboot/Makefile || $(MAKE) -C src/coreboot crossgcc-clean

builddeps-flashrom:: src/flashrom
	$(MAKE) -C $< patchname=_normal PROGRAM=flashrom
	$(MAKE) -C $< patchname=_lenovobios_macronix
	$(MAKE) -C $< patchname=_sst

builddeps-grub:: src/grub
	cd $< && { test -x ./configure || ./autogen.sh; }
	cd $< && { test -f ./Makefile || ./configure --with-platform=coreboot; }
	$(MAKE) -C $<

builddeps-powertop:: src/powertop
	cd $< && { text -x ./configure || ./autogen.sh; }
	cd $< && { test -f ./Makefile || ./configure; }
	$(MAKE) -C $<

builddeps-grubinvaders:: src/grubinvaders
	cd $< && ./compile.sh
cleandeps-grubinvaders::
	test ! -d src/grubinvaders || { cd src/grubinvaders && ./clean.sh; }

builddeps-seabios:: src/seabios resources/seabios/config/config
	cp resources/seabios/config/config $</.config
	$(MAKE) -C $<

builddeps-dejavu:: src/dejavu ;
cleandeps-dejavu:: ;

cleandeps-i945pwm::
	rm -f src/i945pwm/i945-pwm
