dejavu_source       = http://sourceforge.net/projects/dejavu/files/dejavu/2.34/dejavu-fonts-ttf-2.34.tar.bz2

$(foreach arch,$(arches),tmp/builddeps-stamps/$(arch)/dejavu): \
tmp/builddeps-stamps/%/dejavu: src/%/dejavu ; mkdir -p $(@D) && touch $@
cleandeps-%/dejavu-custom: PHONY ;
