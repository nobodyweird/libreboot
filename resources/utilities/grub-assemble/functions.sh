#!/bin/bash

#  grub-assemble gen.sh: general functions used by grub-assemble
#
#	Copyright (C) 2015 Francis Rowe <info@gluglug.org.uk>
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

[ "x${DEBUG+set}" = 'xset' ] && set -v
set -u -e

make_grub_config_file () {
	if (( $# != 2 )); then
		printf "Usage: make_grub_config_file romtype keymap\n"
		printf "romtype can be txtmode or vesafb\n"
		printf "keymaps are defined in git repo /resources/utilities/grub-assemble\n"
		exit 1
	fi

	romtype="${1}"
	keymap="${2}"

	cat "../../grub/config/extra/common.cfg" > "grub_${keymap}_${romtype}.cfg"
	cat "../../grub/config/extra/${romtype}.cfg" >> "grub_${keymap}_${romtype}.cfg"
	printf "keymap %s\n" "${keymap}" >> "grub_${keymap}_${romtype}.cfg"
	cat "../../grub/config/menuentries/common.cfg" >> "grub_${keymap}_${romtype}.cfg"
	cat "../../grub/config/menuentries/${romtype}.cfg" >> "grub_${keymap}_${romtype}.cfg"
	# grubtest.cfg should be able to switch back to grub.cfg
	sed 's/grubtest.cfg/grub.cfg/' < "grub_${keymap}_${romtype}.cfg" > "grub_${keymap}_${romtype}_test.cfg"
}
