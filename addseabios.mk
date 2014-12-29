bin/%_with_seabios.rom: bin/%.rom \
    src/seabios/out/vgabios.bin \
    src/seabios/out/bios.bin.elf \
    resources/grub/config/seabios.cfg \
    $(CBFSTOOL)
	cp $< $@.tmp
	$(CBFSTOOL) $@.tmp add -f src/seabios/out/vgabios.bin -n vgaroms/vgabios.bin -t raw
	$(CBFSTOOL) $@.tmp add -f src/seabios/out/bios.bin.elf -n bios.bin.elf -t raw
	$(CBFSTOOL) $@.tmp extract -n grub.cfg -f $@.tmp.grub.cfg
	$(CBFSTOOL) $@.tmp extract -n grubtest.cfg -f $@.tmp.grubtest.cfg
	$(CBFSTOOL) $@.tmp remove -n grub.cfg
	$(CBFSTOOL) $@.tmp remove -n grubtest.cfg
	cat resources/grub/config/seabios.cfg >> $@.tmp.grub.cfg
	cat resources/grub/config/seabios.cfg >> $@.tmp.grubtest.cfg
	$(CBFSTOOL) $@.tmp add -f $@.tmp.grub.cfg -n grub.cfg -t raw
	$(CBFSTOOL) $@.tmp add -f $@.tmp.grubtest.cfg -n grubtest.cfg -t raw
	rm -f $@.tmp.grub.cfg $@.tmp.grubtest.cfg
	mv $@.tmp $@
