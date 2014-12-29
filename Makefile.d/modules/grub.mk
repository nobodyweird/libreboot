grub_source = git://git.savannah.gnu.org/grub.git\#commit=e2dd6daa8c33e3e7641e442dc269fcca479c6fda

grub_patches = resources/grub/patch/gitdiff
define grub_patch
	cd $@ && git apply $(abspath resources/grub/patch/gitdiff)
endef

grub_configure = --with-platform=coreboot
