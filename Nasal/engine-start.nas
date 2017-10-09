
# Logic to handle startup procedures

var primerTime = 0.0;

var primerTimer = func {
    if (getprop("controls/switches/primer")) {
         primerTime = primerTime + 1.0;
    }
    else {
        primerTime = primerTime - 1.0;
        if (primerTime < 0.0) {
            primerTime = 0.0;
        }
    }
    setprop("controls/engines/engine/primer-time", primerTime);
    if (primerTime > 0.0) {
        settimer(primerTimer, 1.5, 1);
    }
}

var primer = func {
    settimer(primerTimer, 1.5, 1);
}

var throttleState = 0;

var throttleMessage = func (n) {
    var throttlePos = n.getValue();

    if (!getprop("/engines/engine/running")) {
        if (throttlePos >= 0.14 and throttlePos <= 0.18 and throttleState != 1) {
            screen.log.write("Throttle in START position.");
            throttleState = 1;
        }
        else {
            if (throttlePos < 0.14 and throttleState != 2) {
               screen.log.write("Throttle below START position.");
               throttleState = 2
            }
            else {
                if (throttlePos > 0.18 and throttleState != 3) {
                screen.log.write("Throttle above START position");
                throttleState = 3;
                }
            }
        }
    }
    else
        throttleState = 0;
}

setlistener("/controls/switches/primer", primer);

setlistener("/controls/engines/engine/throttle", throttleMessage);

#var init = func {
#	var battery = props.globals.getNode("/controls/engines/engine/master-bat");
#    battery.setBoolValue(0);
#	var alt = props.globals.getNode("/controls/engines/engine/master-alt");
#    alt.setBoolValue(0);
#	removeListener(init_listener);
#}

setlistener("/sim/signals/fdm-initialized", func {
    var battery = props.globals.getNode("/controls/engines/engine/master-bat");
    battery.setBoolValue(0);
    var alt = props.globals.getNode("/controls/engines/engine/master-alt");
    alt.setBoolValue(0);
});

var autostart_listener_id = 0;

var autostart_listener = func (n) {
  if (n.getValue() > 800)
  {
    removelistener(autostart_listener_id);
    autostart_listener_id = 0;
    setprop("/controls/switches/starter", 0);
    setprop("/fdm/jsbsim/propulsion/fuel_pump", 0);

    # Reduce throttle to 0 % after 1.5 seconds
    settimer(func {
        setprop("/controls/engines/engine/throttle", 0);
    }, 1.5 );
  }
}
	
var autostart = func (n) {
    if (getprop("/engines/engine/running")) {
        gui.popupTip("Engine already running", 5);
        return;
    }

    setprop("/aircraft/securing/pitot-cover-visible", 0);

    setprop("/controls/engines/engine/mixture", 0.5);
    setprop("/controls/fuel/on", 1);
    setprop("/controls/engines/engine/master-bat", 1);
    setprop("/controls/engines/engine/master-alt", 1);
    setprop("/controls/armament/gunsight/power-on", 1);
    setprop("/controls/armament/guns-enabled", 1);
    setprop("/controls/armament/gunsight/computer-on", 1);
    setprop("/controls/armament/gunsight/reticleSelectorPos", 1);
    setprop("/controls/gear/brake-parking", 1);
    setprop("/controls/engines/engine/magnetos", 3);
    setprop("/controls/engines/engine/throttle", 0.15);
    setprop("/fdm/jsbsim/propulsion/fuel_pump", 1);
    setprop("/fdm/jsbsim/systems/engine/primed", 1);
    setprop("/controls/engines/engine/primer-time", 17);

    setprop("/controls/lighting/wing-position-lights", 1);
    setprop("/controls/lighting/tail-position-lights", 1);

    if (autostart_listener_id != 0) {
        removelistener(autostart_listener_id);
    }
    autostart_listener_id = setlistener("/engines/engine/rpm", autostart_listener);
    setprop("/controls/switches/starter", 1);
}

