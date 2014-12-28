# Just for convenience
keymapdir = resources/utilities/grub-assemble/keymap

GRUB_MKLAYOUT = src/grub/grub-mklayout
GRUB_MKIMAGE = src/grub/grub-mkimage
GRUB_MKSTANDALONE = src/grub/grub-mkstandalone --grub-mkimage=$(GRUB_MKIMAGE) -d src/grub/grub-core/
CBFSTOOL = src/coreboot/util/cbfstool/cbfstool

boards = x60 t60 x60t macbook21
romtypes = txtmode vesafb
-include $(keymapdir)/list.mk # sets "keymaps=..."

i945boards = x60 x60t t60

build: PHONY \
    $(foreach board,$(boards),\
              $(foreach keymap,$(keymaps),\
                        $(foreach romtype,$(romtypes),\
                                  bin/$(board)_$(keymap)_$(romtype).rom)))


define _nl


endef

# I wrote this between 3AM and 5AM.  I have lost my sanity.
define _loop_rule
_loop_str := $$$$(_nl)$$$$(rule_$1)$$$$(_nl)
_loop_str := $$$$(foreach @,$$$$$$$$@,$$(_loop_str))
_loop_str := $$$$(foreach <,$$$$$$$$<,$$(_loop_str))
$(foreach var,$2,_loop_str := $$$$(foreach $(var),$$$$($(var)s),$$(_loop_str))$(_nl))
endef
define loop_rule
$(eval $(call _loop_rule,$1,$2))
$(eval _loop = $(_loop_str))
$(_loop)
endef



$(keymapdir)/list.mk: $(keymapdir)/original/
	echo keymaps = $$(ls $<) > $@

resources/grub/font/dejavusansmono.pf2: src/dejavu/ttf/DejaVuSansMono.ttf $(firstword $(GRUB_MKFONT))
	$(GRUB_MKFONT) -o $@ $<

# % = $(keymap)
$(keymapdir)/%.gkb: $(keymapdir)/original/% $(firstword $(GRUB_MKLAYOUT))
	$(GRUB_MKLAYOUT) -o $@ < $<

include modules.mk
include build.mk
include grub-mkstandalone.mk
include buildrom-withgrub.mk



.DELETE_ON_ERROR:
PHONY:
.PHONY: PHONY
