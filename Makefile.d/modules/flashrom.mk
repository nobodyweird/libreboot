flashrom_source = svn://flashrom.org/flashrom/trunk\#revision=1854

flashrom_patches = $(wildcard resources/flashrom/patch/flashchips_*.c)
define flashrom_patch
	cp resources/flashrom/patch/flashchips_*.c $@
	sed -i \
	    -e 's/\$$(PROGRAM)\$$(EXEC_SUFFIX)/$$(PROGRAM)$$(patchname)$$(EXEC_SUFFIX)/g' \
	    -e 's/flashchips\.o/flashchips$$(patchname).o/g' \
	    -e 's/libflashrom\.a/libflashrom$$(patchname).a/g' \
	    -e 's/\(rm .*libflashrom\)\S*\.a/\1*.a $$(PROGRAM)_*/' \
	    $@/Makefile
endef

$(foreach arch,$(arches),tmp/builddeps-stamps/$(arch)/flashrom): \
tmp/builddeps-stamps/%/flashrom: src/%/flashrom
	$(MAKE) CC='$(CC)' -C $< patchname=_normal
	$(MAKE) CC='$(CC)' -C $< patchname=_lenovobios_macronix
	$(MAKE) CC='$(CC)' -C $< patchname=_lenovobios_sst
	mkdir -p $(@D)
	touch $@
