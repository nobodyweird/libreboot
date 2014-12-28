define rule_grub_cfg
tmp/grub_$(keymap)_$(romtype).cfg: \
    resources/grub/config/extra/common.cfg     resources/grub/config/menuentries/common.cfg \
    resources/grub/config/extra/$(romtype).cfg resources/grub/config/menuentries/$(romtype).cfg ;
	echo 'keymap $(keymap)' | cat \
		resources/grub/config/extra/common.cfg \
		resources/grub/config/extra/$(romtype).cfg \
		- \
		resources/grub/config/menuentries/common.cfg \
		resources/grub/config/menuentries/$(romtype).cfg \
		> $@
endef
$(eval $(call loop_rule,grub_cfg,keymap romtype))

# % = $(keymap)_$(romtype)
tmp/grub_%_test.cfg: tmp/grub_%.cfg
	sed 's/grubtest.cfg/grub.cfg/' < $< > $@
