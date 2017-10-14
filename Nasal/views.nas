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

var dt = 0.5;
var fast_dt = 0.3;

var reset_view = func (dt) {
    var fow = getprop("sim/current-view/config/default-field-of-view-deg");
    var heading_deg = getprop("sim/current-view/config/heading-offset-deg");
    var pitch_deg = getprop("sim/current-view/config/pitch-offset-deg");
    var roll_deg = getprop("sim/current-view/config/roll-offset-deg");

    var x_offset = getprop("sim/view[0]/config/x-offset-m");
    var y_offset = getprop("sim/view[0]/config/y-offset-m");

    var current_heading_deg = getprop("sim/current-view/heading-offset-deg");

    if (current_heading_deg > 180.0) heading_deg += 360.0;

    interpolate("sim/current-view/field-of-view", fow, dt);
    interpolate("sim/current-view/heading-offset-deg", heading_deg, dt);
    interpolate("sim/current-view/pitch-offset-deg", pitch_deg, dt);
    interpolate("sim/current-view/roll-offset-deg", roll_deg, dt);

    if (getprop("sim/current-view/view-number") == 0) {
        interpolate("sim/current-view/x-offset-m", x_offset, dt);
        interpolate("sim/current-view/y-offset-m", y_offset, dt);
    }
};

var pilot_view = func {
    reset_view(dt);
    if (getprop("sim/current-view/view-number") == 0) {
        var z_offset = getprop("sim/view[0]/config/z-offset-m");
        interpolate("sim/current-view/z-offset-m", z_offset, dt);
    }
};

var hud_view = func {
    if (getprop("sim/current-view/view-number") == 0) {
        var z_offset = getprop("sim/view[0]/config/z-offset-m");

        reset_view(dt);
        interpolate("sim/current-view/z-offset-m", z_offset - 0.2, fast_dt);
    }
};
