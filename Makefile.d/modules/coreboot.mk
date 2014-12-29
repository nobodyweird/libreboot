coreboot_source = git+http://review.coreboot.org/coreboot\#commit=c637a887dde1c63bf3863e70cbe19dedf5f6ca02

coreboot_patches = resources/coreboot/patch/DEBLOB
define coreboot_patch
	# Get patches from review.coreboot.org
	# Text mode patch for X60 native graphics (main patch already merged in coreboot. See 6723 on coreboot gerrit)
	cd $@ && git fetch http://review.coreboot.org/coreboot refs/changes/25/6725/3 && git cherry-pick FETCH_HEAD
	# lenovo/x60: Enable legacy brightness controls (native graphics)
	cd $@ && git fetch http://review.coreboot.org/coreboot refs/changes/48/7048/4 && git cherry-pick FETCH_HEAD
	# Enable T60 native graphics
	cd $@ && git fetch http://review.coreboot.org/coreboot refs/changes/45/5345/9 && git cherry-pick FETCH_HEAD
	# Enable text-mode graphics for T60
	cd $@ && git fetch http://review.coreboot.org/coreboot refs/changes/50/7050/2 && git cherry-pick FETCH_HEAD
	# lenovo/t60: Enable legacy brightness controls (native graphics)
	cd $@ && git fetch http://review.coreboot.org/coreboot refs/changes/51/7051/1 && git cherry-pick FETCH_HEAD
	# ec/lenovo/h8: permanently enable wifi/trackpoint/touchpad/bluetooth/wwan
	cd $@ && git fetch http://review.coreboot.org/coreboot refs/changes/58/7058/7 && git cherry-pick FETCH_HEAD
	# i945: permanently set tft_brightness to 0xff. this fixes the issue with X60 and "scrolling" backlight
	cd $@ && git fetch http://review.coreboot.org/coreboot refs/changes/61/7561/2 && git cherry-pick FETCH_HEAD
	# Note: macbook21 already has backlight control.
	# Deblob coreboot
	cd $@ && $(abspath resources/coreboot/patch/DEBLOB)
endef


# Generate sub-source directories by generating the parent source directory
coreboot_utils = cbfstool nvramtool crossgcc
define rule_coreboot_utils
src/%(arch)/coreboot/util/%(coreboot_util): | src/%(arch)/coreboot
	test -d $@
endef
$(eval $(call multiglob,coreboot_utils,arch coreboot_utils))

# The builddeps stamp needs to depend on 3 "utility" builddeps
$(foreach arch,$(arches),tmp/builddeps-stamps/$(arch)/coreboot): \
tmp/builddeps-stamps/%/coreboot: \
    tmp/builddeps-stamps/%/coreboot-cbfstool \
    tmp/builddeps-stamps/%/coreboot-nvramtool \
    tmp/builddeps-stamps/%/coreboot-crossgcc
	touch $@

# The 3 actual utility builddeps:
tmp/builddeps-stamps/%/coreboot-cbfstool: src/%/coreboot/util/cbfstool
	$(MAKE) -C $<
	mkdir -p $(@D)
	touch $@
tmp/builddeps-stamps/%/coreboot-nvramtool: src/%/coreboot/util/nvramtool
	$(MAKE) -C $<
	mkdir -p $(@D)
	touch $@
tmp/builddeps-stamps/%/coreboot-crossgcc: src/%/coreboot/util/crossgcc
	$(MAKE) -C src/$*/coreboot crossgcc-i386
	mkdir -p $(@D)
	touch $@

cleandeps-%/coreboot-custom: PHONY
	test ! -f src/%/coreboot/Makefile || $(MAKE) -C src/%/coreboot clean
	test ! -f src/%/coreboot/Makefile || $(MAKE) -C src/%/coreboot/util/cbfstool clean
	test ! -f src/%/coreboot/Makefile || $(MAKE) -C src/%/coreboot/util/nvramtool clean
	test ! -f src/%/coreboot/Makefile || $(MAKE) -C src/%/coreboot crossgcc-clean
	rm -f tmp/builddeps-stamps/%/coreboot-*
