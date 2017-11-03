# Copyright (C) 2017  onox
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

var on_ground_menu_items = [
    "fuel-and-payload",
    "p51d-stores-none",
    "p51d-stores-bombs",
    "p51d-stores-rockets",
    "p51d-stores-bombs-rockets",
    "p51d-stores-tanks",
    "p51d-stores-tanks-rockets",
    "p51d-stores-load-guns",
    "p51d-stores-unload-guns",
    "p51d-autostart",
];

setlistener("/gear/on-ground-at-rest", func (node) {
    var on_ground = node.getBoolValue();

    foreach (var menuitem; on_ground_menu_items) {
        gui.menuEnable(menuitem, on_ground);
    }
}, 1, 0);

# The P-51D has no autopilot or GPS, so disable the menu
gui.menuEnable("autopilot", 0);
gui.menuEnable("gps", 0);

gui.menuEnable("adjust-hud", 0);
gui.menuEnable("jetway", 0);
