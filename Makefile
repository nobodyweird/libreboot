VERSION := $(shell if test -f version.txt; then cat version.txt; else git describe; fi)
host_arch := $(shell uname -m)
#export CC := $(CC) -static

# Just for convenience
keymapdir = resources/utilities/grub-assemble/keymap

GRUB_MKFONT = src/$(host_arch)/grub/grub-mkfont
GRUB_MKLAYOUT = src/$(host_arch)/grub/grub-mklayout
GRUB_MKIMAGE = src/$(host_arch)/grub/grub-mkimage
GRUB_MKSTANDALONE = src/$(host_arch)/grub/grub-mkstandalone --grub-mkimage=$(GRUB_MKIMAGE) -d src/$(host_arch)/grub/grub-core/
CBFSTOOL = src/$(host_arch)/coreboot/util/cbfstool/cbfstool

arches = i686 x86_64
archs = $(arches)
boards = x60 t60 x60t macbook21
romtypes = txtmode vesafb
-include Makefile.d/keymap-list.mk # sets "keymaps=..."

i945boards = x60 x60t t60

roms = $(foreach board,$(boards),\
                 $(foreach keymap,$(keymaps),\
                           $(foreach romtype,$(romtypes),\
                                     $(board)_$(keymap)_$(romtype))))

build: PHONY \
	$(foreach rom,$(roms),roms/$(rom).rom roms/$(rom)_with_seabios.rom) \
	src/$(host_arch)/flashrom/flashrom_normal \
	src/$(host_arch)/flashrom/flashrom_lenovobios_macronix \
	src/$(host_arch)/flashrom/flashrom_lenovobios_sst \
	src/$(host_arch)/bucts/bucts



define _nl


endef
multiglob = $(if $(strip $2),\
                 $(foreach item,$($(firstword $2)s),\
                           $(subst %($(firstword $2)),$(item),\
                                   $(call multiglob,$1,$(wordlist 2,$(words $2),$2)))),\
                 $(_nl)$(value rule_$1)$(_nl))



configure: configure.ac
	autoconf

Makefile.d/keymap-list.mk: $(keymapdir)/original/ Makefile
	echo keymaps = $(notdir $(wildcard $</*)) > $@
Makefile.d/modules-list.mk: Makefile.d/modules/ Makefile
	echo modules = $(patsubst %.mk,%,$(notdir $(wildcard $</*.mk))) > $@

resources/grub/font/dejavusansmono.pf2: src/$(host_arch)/dejavu/ttf/DejaVuSansMono.ttf $(firstword $(GRUB_MKFONT))
	$(GRUB_MKFONT) -o $@ $<

# % = $(keymap)
$(keymapdir)/%.gkb: $(keymapdir)/original/% $(firstword $(GRUB_MKLAYOUT))
	$(GRUB_MKLAYOUT) -o $@ < $<

-include Makefile.d/modules-list.mk # sets "modules=..."
include $(patsubst %,Makefile.d/modules/%.mk,$(modules))
include Makefile.d/modules.mk
include Makefile.d/build.mk
include Makefile.d/grub-mkstandalone.mk
include Makefile.d/buildrom-withgrub.mk
include Makefile.d/addseabios.mk

# It is important that build-release.mk is LAST, as it uses
# MAKEFILE_LIST to know which files to copy.
include Makefile.d/build-release.mk



.DELETE_ON_ERROR:
PHONY:
.PHONY: PHONY
