#
#	Copyright (C) 2014 Francis Rowe <info@gluglug.org.uk>
#	Copyright (C) 2014 Luke Shumaker <lukeshu@sbcglobal.net>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

define rule_grub_cfg
tmp/grub_%(keymap)_%(romtype).cfg: \
    resources/grub/config/extra/common.cfg     resources/grub/config/menuentries/common.cfg \
    resources/grub/config/extra/%(romtype).cfg resources/grub/config/menuentries/%(romtype).cfg ;
	echo 'keymap %(keymap)' | cat \
		resources/grub/config/extra/common.cfg \
		resources/grub/config/extra/%(romtype).cfg \
		- \
		resources/grub/config/menuentries/common.cfg \
		resources/grub/config/menuentries/%(romtype).cfg \
		> $@
endef
$(eval $(call multiglob,grub_cfg,keymap romtype))

# % = %(keymap)_%(romtype)
tmp/grub_%_test.cfg: tmp/grub_%.cfg
	sed 's/grubtest.cfg/grub.cfg/' < $< > $@
