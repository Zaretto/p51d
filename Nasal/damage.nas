# Copyright (C) 2016  onox
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

# Duration in which no damage will occur. Assumes the aircraft has
# stabilized within this duration.
var repair_timeout = 3.0;

var repair_damage = func {
    setprop("/fdm/jsbsim/damage/repairing", 1);
    sounds.play("engine-repair", 6.0);

    # Repair all damage
    foreach (var mode_id; keys(FailureMgr._failmgr.failure_modes)) {
        FailureMgr.set_failure_level(mode_id, 0);
    }

    # Reset circuit breakers and recharge battery
    #electrical.reset_battery_and_circuit_breakers();

    repair_timer.restart(repair_timeout);
};

# This timer object is used to enable damage again a short time after
# changing to the last bush kit option.
var repair_timer = maketimer(repair_timeout, func {
    setprop("/fdm/jsbsim/damage/repairing", 0);
});
repair_timer.singleShot = 1;

setlistener("/fdm/jsbsim/damage/repairing", func (node) {
    if (node.getBoolValue())
        logger.screen.white("Repairing damage...");
    else
        logger.screen.green("Damage repaired");
}, 0, 0);

setlistener("/fdm/jsbsim/systems/crash-detect/impact", func (n) {
    if (n.getBoolValue())
        # Engine
        setprop("/sim/failure-manager/engines/engine/serviceable", 0);

        # Engine driven vacuum pump (TODO fail sometimes)
        setprop("/sim/failure-manager/systems/vacuum/serviceable", 0);
        # TODO set cooling factor to 0

        # Pitot tube under right wing
        setprop("/sim/failure-manager/systems/pitot/serviceable", 0);

        # TODO fail coolant + oil radiator doors
        # TODO fail gear
        # TODO fail flaps (sometimes)
}, 0, 0);
