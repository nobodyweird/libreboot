# Easy names for tmp/builddeps-stamps/%
$(foreach arch,$(arches),$(foreach module,$(modules), builddeps-$(arch)/$(module) )): builddeps-%: PHONY tmp/builddeps-stamps/%

# The "all" rules
getdeps:   $(foreach arch,$(arches),$(foreach module,$(modules), src/$(arch)/$(module)       )) 
builddeps: $(foreach arch,$(arches),$(foreach module,$(modules), builddeps-$(arch)/$(module) ))
cleandeps: $(foreach arch,$(arches),$(foreach module,$(modules), cleandeps-$(arch)/$(module) ))
	rm -rf roms/* tmp/*

# If we depend on a file in src/$(arch)/$(module)/, tell Make that we
# should generate it by calling the builddep rule.
define rule_module_files
src/%(arch)/%(module)/%: | tmp/builddeps-stamps/%(arch)/%(module)
	test -e $@
endef
$(eval $(call multiglob,module_files,arch module))

# The generic rules

# "get" rules
define rule_download
src/%(arch)/%(module): Makefile.d/downloader Makefile.d/modules/%(module).mk $(%(module)_patches)
	Makefile.d/downloader %(arch) %(module)::$(%(module)_source)
	$(%(module)_patch)
	test -d $@
	touch $@
endef
$(eval $(call multiglob,download,arch module))

# "builddeps" and "cleandeps" rules
# % = arch/module
tmp/builddeps-stamps/%: src/%
	cd $< && { test -f ./Makefile || test -x ./configure || ./autogen.sh; }
	cd $< && { test -f ./Makefile || ./configure $($(*F)_configure); }
	$(MAKE) -C $<
	mkdir -p $(@D)
	touch $@

# "cleandeps" rules
$(foreach arch,$(arches),$(foreach module,$(modules), cleandeps-$(arch)/$(module) )): \
cleandeps-%: PHONY cleandeps-%-custom
	rm -f tmp/builddeps-stamps/%
cleandeps-%-custom: PHONY
	test ! -f src/$*/Makefile || $(MAKE) -C src/$* clean
