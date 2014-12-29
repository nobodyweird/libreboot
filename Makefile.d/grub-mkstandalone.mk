include resources/utilities/grub-assemble/modules.conf

grub_txtmode_memdisk_grafts = \
	/memtest=src/$(host_arch)/memtest86/memtest \
	/invaders.exec=src/$(host_arch)/grubinvaders/invaders.exec
grub_vesafb_memdisk_grafts = \
	/background.jpg=resources/grub/background/background.jpg \
	/dejavusansmono.pf2=resources/grub/font/dejavusansmono.pf2

grub_txtmode_memdisk_deps = $(foreach graft,$(grub_txtmode_memdisk_grafts),$(lastword $(subst =, ,$(graft))))
grub_vesafb_memdisk_deps  = $(foreach graft,$(grub_vesafb_memdisk_grafts) ,$(lastword $(subst =, ,$(graft))))

# A rule-variable is used here to avoid needing .SECONDEXPANSION
define rule_grub_elf
tmp/grub_%(romtype).elf: \
    tmp/builddeps-stamps/$(host_arch)/grub \
    $(keymapdir)/list.mk resources/utilities/grub-assemble/modules.conf \
    resources/grub/config/grub_memdisk.cfg \
    $(grub_%(romtype)_memdisk_deps) \
    $(firstword $(GRUB_MKSTANDALONE)) \
    $(foreach k,$(keymaps),$(keymapdir)/$k.gkb)
	$(GRUB_MKSTANDALONE) -o $@  -O i386-coreboot \
	  --fonts= --themes= --locales=  \
	  --modules='$(grub_modules)' \
	  --install-modules='$(grub_install_modules)' \
	  /boot/grub/grub.cfg="resources/grub/config/grub_memdisk.cfg" \
	  $(grub_%(romtype)_memdisk_grafts) \
	  $(foreach k,$(keymaps),/boot/grub/layouts/$k.gkb=$(keymapdir)/$k.gkb)
	test -e $@
endef
$(eval $(call multiglob,grub_elf,romtype))
