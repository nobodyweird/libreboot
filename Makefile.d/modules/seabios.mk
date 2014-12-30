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

seabios_source = git://git.seabios.org/seabios.git\#commit=9f505f715793d99235bd6b4afb2ca7b96ba5729b

$(foreach arch,$(arches),tmp/builddeps-stamps/$(arch)/seabios): \
tmp/builddeps-stamps/%/seabios: src/%/seabios resources/seabios/config/config
	cp resources/seabios/config/config $</.config
	$(MAKE) CC='$(CC)' -C $<
	mkdir -p $(@D)
	touch $@
