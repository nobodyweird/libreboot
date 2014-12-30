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

roms/%_with_seabios.rom: roms/%.rom \
    src/$(host_arch)/seabios/out/vgabios.bin \
    src/$(host_arch)/seabios/out/bios.bin.elf \
    resources/grub/config/seabios.cfg \
    $(CBFSTOOL)
	cp $< $@.tmp
	$(CBFSTOOL) $@.tmp add -f src/$(host_arch)/seabios/out/vgabios.bin -n vgaroms/vgabios.bin -t raw
	$(CBFSTOOL) $@.tmp add -f src/$(host_arch)/seabios/out/bios.bin.elf -n bios.bin.elf -t raw
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
