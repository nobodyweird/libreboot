#
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

-include config.mk
host_arch := $(shell uname -m)

export SHARED=0
export CC = gcc $(if $(MAINTAINER_MODE),-static) $(if $(findstring i686,$@),-m32,-m64)

# Just for convenience
keymapdir = resources/utilities/grub-assemble/keymap

GRUB_MKFONT = src/$(host_arch)/grub/grub-mkfont
GRUB_MKLAYOUT = src/$(host_arch)/grub/grub-mklayout
GRUB_MKIMAGE = src/$(host_arch)/grub/grub-mkimage
GRUB_MKSTANDALONE = src/$(host_arch)/grub/grub-mkstandalone --grub-mkimage=$(GRUB_MKIMAGE) -d src/$(host_arch)/grub/grub-core/
CBFSTOOL = src/$(host_arch)/coreboot/util/cbfstool/cbfstool

arches := $(sort $(host_arch) i686)
archs = $(arches)
boards = x60 t60 x60t macbook21
romtypes = txtmode vesafb
-include Makefile.d/keymap-list.mk # sets "keymaps=..."

i945boards = x60 x60t t60

roms = $(foreach board,$(boards),\
                 $(foreach keymap,$(keymaps),\
                           $(foreach romtype,$(romtypes),\
                                     $(board)_$(keymap)_$(romtype))))

all: PHONY build

build: PHONY roms $(if $(MAINTAINER_MODE),$(addprefix tools-,$(arches)),tools)
roms: PHONY $(foreach rom,$(roms),roms/$(rom).rom roms/$(rom)_with_seabios.rom)

tools: PHONY tools-$(host_arch)
$(addprefix tools-,$(arches)): tools-%: PHONY \
	src/%/bucts/bucts \
	src/%/flashrom/flashrom_normal \
	src/%/flashrom/flashrom_lenovobios_macronix \
	src/%/flashrom/flashrom_lenovobios_sst \
	src/%/coreboot/util/cbfstool/cbfstool \
	src/%/coreboot/util/cbfstool/rmodtool \
	src/%/coreboot/util/nvramtool/nvramtool


# Multiglob magic

define _nl


endef
multiglob = $(if $(strip $2),\
                 $(foreach item,$($(firstword $2)s),\
                           $(subst %($(firstword $2)),$(item),\
                                   $(call multiglob,$1,$(wordlist 2,$(words $2),$2)))),\
                 $(_nl)$(value rule_$1)$(_nl))


# Normal make rules

configure: configure.ac
	autoconf

config.mk: configure config.mk.in
	./configure

Makefile.d/keymap-list.mk: $(keymapdir)/original/
	echo keymaps = $(notdir $(wildcard $</*)) > $@

Makefile.d/modules-list.mk: Makefile.d/modules/
	echo modules = $(patsubst %.mk,%,$(notdir $(wildcard $</*.mk))) > $@

resources/grub/font/dejavusansmono.pf2: src/$(host_arch)/dejavu/ttf/DejaVuSansMono.ttf $(firstword $(GRUB_MKFONT))
	$(GRUB_MKFONT) -o $@ $<

# % = %(keymap)
$(keymapdir)/%.gkb: $(keymapdir)/original/% $(firstword $(GRUB_MKLAYOUT))
	$(GRUB_MKLAYOUT) -o $@ < $<


# Includes

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
.SECONDARY:
.PHONY: PHONY
PHONY:
