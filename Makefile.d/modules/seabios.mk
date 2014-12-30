seabios_source = git://git.seabios.org/seabios.git\#commit=9f505f715793d99235bd6b4afb2ca7b96ba5729b

$(foreach arch,$(arches),tmp/builddeps-stamps/$(arch)/seabios): \
tmp/builddeps-stamps/%/seabios: src/%/seabios resources/seabios/config/config
	cp resources/seabios/config/config $</.config
	$(MAKE) CC='$(CC)' -C $<
	mkdir -p $(@D)
	touch $@
