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

# Position and offset of the pilot's head
var pilot = {
    x: 3.2900,
    y: 0.0000,
    z: 0.5220,
};

var PilotHeadUpdater = {

    new: func {
        var m = {
            parents: [PilotHeadUpdater]
        };
        m.loop = updateloop.UpdateLoop.new(components: [m], update_period: 0.0, enable: 0);
        return m;
    },

    enable: func {
        me.loop.reset();
        me.loop.enable();
    },

    disable: func {
        me.loop.disable();
    },

    enable_or_disable: func (enable) {
        if (enable)
            me.enable();
        else
            me.disable();
    },

    reset: func {
        setprop("/aircraft/pilot/head/heading-deg", 0.0);
        setprop("/aircraft/pilot/head/pitch-deg", 0.0);
    },

    update: func (dt) {
        var roll_deg  = getprop("/orientation/roll-deg");
        var pitch_deg = getprop("/orientation/pitch-deg");
        var heading   = getprop("/orientation/heading-deg");

        var view_point = me._get_view_position(roll_deg, pitch_deg, heading);

        # Compute the actual position of pilot's head
        var (start_point_2d, start_point) = math_ext.get_point(pilot.x, pilot.y, pilot.z, roll_deg, pitch_deg, heading);

        var (yaw, pitch, distance) = math_ext.get_yaw_pitch_distance_inert(start_point_2d, start_point, view_point, heading);
        (yaw, pitch) = math_ext.get_yaw_pitch_body(roll_deg, pitch_deg, yaw, pitch);

        setprop("/aircraft/pilot/head/heading-deg", yaw - 180.0);
        setprop("/aircraft/pilot/head/pitch-deg", pitch);
    },

    _get_view_position: func (roll_deg, pitch_deg, heading) {
        # The provided properties (viewer-*) in /sim/current-view don't
        # do their job, so we have to construct the position manually.

        var x = getprop("/sim/current-view/target-z-offset-m");
        var y = getprop("/sim/current-view/target-x-offset-m");
        var z = getprop("/sim/current-view/target-y-offset-m");

        var (point_2d, point) = math_ext.get_point(x, y, z, roll_deg, pitch_deg, heading);

        var view_heading_deg = getprop("/sim/current-view/heading-offset-deg");
        var view_pitch_deg   = getprop("/sim/current-view/pitch-offset-deg");

        var (yaw, pitch) = math_ext.get_yaw_pitch_body(roll_deg, pitch_deg, view_heading_deg, view_pitch_deg);

        var distance = -getprop("/sim/current-view/z-offset-m");
        var z = distance * math_ext.sin(pitch);
        var a = distance * math_ext.cos(pitch);

        var x = -a * math_ext.cos(yaw);
        var y =  a * math_ext.sin(yaw);

        var (point2_2d, point2) = math_ext.get_point(x, y, z, roll_deg, pitch_deg, heading, point);
        return point2;
    },

};

var head_updater  = PilotHeadUpdater.new();

setlistener("/sim/signals/fdm-initialized", func {
    setlistener("/sim/current-view/internal", func (node) {
        head_updater.enable_or_disable(!node.getValue());
    }, 1, 0);
});
