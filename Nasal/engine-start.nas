
# Logic to handle startup procedures

var primerTime = 0.0;

controls.startEngine = func(v) {
    var starter = props.globals.getNode("/controls/engines/engine/starter");
	var battery = getprop("/controls/engines/engine/master-bat");
	starter.setBoolValue(v and battery == 1);
}

var primerTimer = func {
    if (getprop("controls/engines/engine/primer-on") == 1) {
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

setlistener("/controls/engines/engine/primer-on", primer);

setlistener("/controls/engines/engine/throttle", throttleMessage);

#var init = func {
#	var battery = props.globals.getNode("/controls/engines/engine/master-bat");
#    battery.setBoolValue(0);
#	var alt = props.globals.getNode("/controls/engines/engine/master-alt");
#    alt.setBoolValue(0);
#	removeListener(init_listener);
#}

var init_listener = setlistener("/sim/signals/fdm-initialized", func {	
    	var battery = props.globals.getNode("/controls/engines/engine/master-bat");
        battery.setBoolValue(0);
    	var alt = props.globals.getNode("/controls/engines/engine/master-alt");
        alt.setBoolValue(0);
	    removelistener(init_listener);
	  }
	);

var autostart_listener_id = 0;
var autostart_listener_called = 0;
var autostart_listener = func(n) {
  if (! autostart_listener_called and n.getValue() > 800)
  {
    autostart_listener_called = 1;
    # Hack to work around the inability to set a tied variable
    # (/controls/engines/engine/starter) in a listener callback.
    settimer(func { controls.startEngine(0) },0);
    setprop("/fdm/jsbsim/systems/engine/starter", 0);
    setprop("/fdm/jsbsim/propulsion/fuel_pump", 0);
    settimer(func { setprop("/controls/engines/engine/throttle", 0) }, 1.5 );
    removelistener(autostart_listener_id);
    autostart_listener_called  = 0;
  }
}
	
var autostart = func (n) {
    setprop("/controls/engines/engine/mixture", 0.5);
    setprop("/controls/fuel/on", 1);
    setprop("/controls/engines/engine/master-bat", 1);
    setprop("/controls/armament/gunsight/power-on", 1);
    setprop("/controls/armament/guns-enabled", 1);
    setprop("/controls/armament/gunsight/computer-on", 1);
    setprop("/controls/gear/brake-parking", 1);
    setprop("/controls/engines/engine/magnetos", 3);
    setprop("/controls/engines/engine/throttle", 0.15);
    setprop("/fdm/jsbsim/propulsion/fuel_pump", 1);
    setprop("/fdm/jsbsim/systems/engine/primed", 1);
    setprop("/controls/engines/engine/primer-time", 17);

    autostart_listener_id = setlistener("/engines/engine/rpm", autostart_listener);
    setprop("/fdm/jsbsim/systems/engine/starter", 1);
    setprop("/controls/engines/engine/starter", 1);
    controls.startEngine(1);
}

