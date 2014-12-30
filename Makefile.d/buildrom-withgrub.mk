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

# % = %(board)
resources/libreboot/config/%_vesafb_config: resources/libreboot/config/%_txtmode_config
	sed 's/# CONFIG_FRAMEBUFFER_KEEP_VESA_MODE is not set/CONFIG_FRAMEBUFFER_KEEP_VESA_MODE=y/' < $< > $@

# Unfortunately, this rule requires exclusive use of the src/coreboot directory
.NOTPARALLEL:
define rule_rom_nokeyboard
tmp/%(board)_nokeyboard_%(romtype).rom: tmp/builddeps-stamps/$(host_arch)/coreboot \
    tmp/grub_%(romtype).elf \
    resources/libreboot/config/%(board)_%(romtype)_config
	rm -f src/$(host_arch)/coreboot/.config src/$(host_arch)/coreboot/grub.elf
	$(MAKE) -C src/$(host_arch)/coreboot clean
	ln resources/libreboot/config/%(board)_%(romtype)_config src/$(host_arch)/coreboot/.config
	ln tmp/grub_%(romtype).elf src/$(host_arch)/coreboot/grub.elf
	$(MAKE) -C src/$(host_arch)/coreboot
	rm -f src/$(host_arch)/coreboot/.config src/$(host_arch)/coreboot/grub.elf
	mv src/$(host_arch)/coreboot/build/coreboot.rom $@
endef
$(eval $(call multiglob,rom_nokeyboard,board romtype))

define rule_rom
roms/%(board)_%(keymap)_%(romtype).rom: \
    tmp/%(board)_nokeyboard_%(romtype).rom \
    tmp/grub_%(keymap)_%(romtype).cfg \
    tmp/grub_%(keymap)_%(romtype)_test.cfg \
    $(firstword $(CBFSTOOL))
	cp $< $@.tmp
	$(CBFSTOOL) $@.tmp add -f tmp/grub_%(keymap)_%(romtype).cfg -n grub.cfg -t raw
	$(CBFSTOOL) $@.tmp add -f tmp/grub_%(keymap)_%(romtype)_test.cfg -n grubtest.cfg -t raw
# Needed on i945 systems for the bucts/dd trick (documented)
# This enables the ROM to be flashed over the lenovo bios firmware
	$(if $(filter %(board),$(i945boards)),\
		dd if='$@.tmp' of='$@.tmp.top64k' bs=1 skip=$$[$$(stat -c %s '$@.tmp') - 0x10000] count=64k && \
		dd if='$@.tmp.top64k' of='$@.tmp' bs=1 seek=$$[$$(stat -c %s '$@.tmp') - 0x20000] count=64k conv=notrunc && \
		rm -f '$@.tmp.top64k')
	mv -f $@.tmp $@
endef
$(eval $(call multiglob,rom,board keymap romtype))
