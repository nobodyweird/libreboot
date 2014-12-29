memtest86_source = http://www.memtest.org/download/5.01/memtest86+-5.01.tar.gz

memtest86_patches = resources/memtest86/patch/config.h resources/memtest86/patch/Makefile
define memtest86_patch
	cp -f resources/memtest86/patch/config.h $@/config.h
	cp -f resources/memtest86/patch/Makefile $@/Makefile
endef
