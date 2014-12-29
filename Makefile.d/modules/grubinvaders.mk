grubinvaders_source = http://www.erikyyy.de/invaders/invaders-1.0.0.tar.gz

grubinvaders_patches = resources/grubinvaders/patch/diff.patch resources/grubinvaders/patch/compile.sh.patch
define grubinvaders_patch
	# Apply patch mentioned on http://www.coreboot.org/GRUB_invaders
	cd $@ && patch < $(abspath resources/grubinvaders/patch/diff.patch)
	cd $@ && patch compile.sh < $(abspath resources/grubinvaders/patch/compile.sh.patch)
endef

$(foreach arch,$(arches),tmp/builddeps-stamps/$(arch)/grubinvaders): \
tmp/builddeps-stamps/%/grubinvaders: src/%/grubinvaders
	cd $< && ./compile.sh
	mkdir -p $(@D)
	touch $@
cleandeps-%/grubinvaders-custom: PHONY
	test ! -d src/%/grubinvaders || { cd src/%/grubinvaders && ./clean.sh; }
