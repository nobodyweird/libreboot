# % = $(board)
resources/libreboot/config/%_vesafb_config: resources/libreboot/config/%_txtmode_config
	sed 's/# CONFIG_FRAMEBUFFER_KEEP_VESA_MODE is not set/CONFIG_FRAMEBUFFER_KEEP_VESA_MODE=y/' < $< > $@

define rule_rom_nokeyboard
tmp/$(board)_nokeyboard_$(romtype).rom: builddeps-coreboot \
    tmp/grub_$(romtype).elf \
    resources/libreboot/config/$(board)_$(romtype)_config
	rm -f src/coreboot/.config src/coreboot/grub.elf
	$(MAKE) -C src/coreboot clean
	ln resources/libreboot/config/$(board)_$(romtype)_config src/coreboot/.config
	ln tmp/grub_$(romtype).elf src/coreboot/grub.elf
	$(MAKE) -C src/coreboot
	rm -f src/coreboot/.config src/coreboot/grub.elf
	mv src/coreboot/build/coreboot.rom $@
endef
$(eval $(call loop_rule,rom_nokeyboard,board romtype))

define rule_rom
bin/$(board)_$(keymap)_$(romtype).rom: \
    tmp/$(board)_nokeyboard_$(romtype).rom \
    tmp/grub_$(keymap)_$(romtype).cfg \
    tmp/grub_$(keymap)_$(romtype)_test.cfg \
    $(firstword $(CBFSTOOL))
	cp $< $@.tmp
	$(CBFSTOOL) $@.tmp add -f tmp/grub_$(keymap)_$(romtype).cfg -n grub.cfg -t raw
	$(CBFSTOOL) $@.tmp add -f tmp/grub_$(keymap)_$(romtype)_test.cfg -n grubtest.cfg -t raw
	$(if $(filter $(board),$(i945boards)),\
		# Needed on i945 systems for the bucts/dd trick (documented)
		# This enables the ROM to be flashed over the lenovo bios firmware
		dd if='$@.tmp' of='$@.tmp.top64k' bs=1 skip=$$[$$(stat -c %s '$@.tmp') - 0x10000] count=64k && \
		dd if='$@.tmp.top64k' of='$@.tmp' bs=1 seek=$$[$$(stat -c %s '$@.tmp') - 0x20000] count=64k conv=notrunc && \
		rm -f '$@.tmp.top64k')
	mv $@.tmp $@
endef
$(eval $(call loop_rule,rom,board keymap romtype))
