#!/bin/bash # not executable, but as a hint to text editors

bucts_source='git://git.stuge.se/bucts.git#commit=dc27919d7a66a6e8685ce07c71aefa4f03ef7c07'

coreboot_source='git+http://review.coreboot.org/coreboot#commit=c637a887dde1c63bf3863e70cbe19dedf5f6ca02' 
coreboot_mksource() {
	cd "$srcdir"/coreboot
	# Get patches from review.coreboot.org
	patches=(
		# Text mode patch for X60 native graphics (main patch already merged in coreboot. See 6723 on coreboot gerrit)
		refs/changes/25/6725/3
		# lenovo/x60: Enable legacy brightness controls (native graphics)
		refs/changes/48/7048/4
		# Enable T60 native graphics
		refs/changes/45/5345/9
		# Enable text-mode graphics for T60
		refs/changes/50/7050/2
		# lenovo/t60: Enable legacy brightness controls (native graphics)
		refs/changes/51/7051/1
		# ec/lenovo/h8: permanently enable wifi/trackpoint/touchpad/bluetooth/wwan
		refs/changes/58/7058/7
		# i945: permanently set tft_brightness to 0xff. this fixes the issue with X60 and "scrolling" backlight
		refs/changes/61/7561/2
		# Note: macbook21 already has backlight control.
	)
	for patch in "${patches[@]}"; do
		git fetch http://review.coreboot.org/coreboot "$patch"
		git cherry-pick FETCH_HEAD
	done
	# Deblob coreboot
	"$resources"/coreboot/patch/DEBLOB
}

flashrom_source='flashrom::svn://flashrom.org/flashrom/trunk#revision=1854'
flashrom_mksource() {
	cd "$srcdir"/flashrom
	cp "$resources"/flashrom/patch/flashchips_*.c .
	sed -i \
	    -e 's/^CFLAGS\s*?=.*/& -static/' \
	    -e 's/^PROGRAM\s*=/PROGRAM = flashrom$(patchname)/' \
	    -e 's/flashchips\.o/flashchips$(patchname).o/g' \
	    -e 's/libflashrom\.a/libflashrom$(patchname).a/g' \
	    -e 's/\(rm .*libflashrom\)\S*\.a/\1*.a $(PROGRAM)_*/' \
	    Makefile
}

grub_source='git://git.savannah.gnu.org/grub.git#commit=e2dd6daa8c33e3e7641e442dc269fcca479c6fda'
grub_mksource() {
	cd "$srcdir"/grub
	git apply "$resources"/grub/patch/gitdiff
}

memtest86_source='http://www.memtest.org/download/5.01/memtest86+-5.01.tar.gz'
memtest86_mksource() {
	rm -rf "$srcdir"/memtest86
	mv "$srcdir"/memtest86{+-5.01,}
	cd "$srcdir"/memtest86
	cp -f "$resources"/memtest86/patch/config.h ./config.h
	cp -f "$resources"/memtest86/patch/Makefile ./Makefile
}

seabios_source='git://git.seabios.org/seabios.git#commit=9f505f715793d99235bd6b4afb2ca7b96ba5729b'

grubinvaders_source='http://www.erikyyy.de/invaders/invaders-1.0.0.tar.gz'
grubinvaders_mksource() {
	rm -rf "$srcdir"/grubinvaders
	mv "$srcdir"/{,grub}invaders
	cd "$srcdir"/grubinvaders
	# Apply patch mentioned on http://www.coreboot.org/GRUB_invaders
	patch < "$resources"/grubinvaders/patch/diff.patch
	patch compile.sh < "$resources"/grubinvaders/patch/compile.sh.patch
}

i945pwm_source='i945pwm::git://git.mtjm.eu/i945-pwm.git#commit=d88c8b290b9473e071d24cd3b97f4a091ee398cf'

dejavu_source='http://sourceforge.net/projects/dejavu/files/dejavu/2.34/dejavu-fonts-ttf-2.34.tar.bz2'
dejavu_mksource() {
	rm -rf "$srcdir"/dejavu
	mv "$srcdir"/dejavu{-fonts-ttf-2.34,}
}

# this version of powertop is just for Trisquel 6 users
powertop_source='git+https://github.com/fenrus75/powertop.git#e70c89eb5d7b6b8f898bb126adefcbf3202d5acf'
