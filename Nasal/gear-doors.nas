#
# Nasal script to open and close main gear inner doors based on engine running.

var state = 0;  # engine is not started or just got started
var pos = 0.2;
var loopid = 0;
var running = 0;

var gearDoors = func(id) {

    print("gearDoors");

   id == loopid or return;
   var running = getprop("fdm/jsbsim/propulsion/engine/set-running");
   var pos = getprop("/fdm/jsbsim/systems/gear/doors-engine");

   # initialization
   if (running == 0 and state == 0) {
      setprop("/fdm/jsbsim/systems/gear/doors-engine", 0.2);
   }
   else {
        # engine just started
        if (state = 0 and running == 1) {
            setprop("/fdm/jsbsim/systems/gear/doors-transition", 1);
            if (pos > 0.0) {
                pos = pos - 0.01;
                if (pos < 0.0)  pos = 0.0;
            }
            else {
            state = 1;
            loopid += 1;
            setprop("/fdm/jsbsim/systems/gear/doors-transition", 0);
            }
        }
        # engine just stopped
        if (state == 1 and running == 0) {
            setprop("/fdm/jsbsim/systems/gear/doors-transition", 1);
                if (pos < 0.2) {
                    pos = pos + 0.01;
                    if (pos > 0.2)  pos = 0.2;
                }
                if (pos > 0.2) {
                    pos = pos - 0.01;
                    if (pos < 0.2)  pos = 0.2;
                }
                if (pos = 0.2) {
                    state = 0;
                    loopid += 1;
                    setprop("/fdm/jsbsim/systems/gear/doors-transition", 0);
                }
            }
        setprop("/fdm/jsbsim/systems/gear/doors-engine", pos);
        settimer(func{gearDoors(id)}, 0.25);
   }
}

var engineStateChange = func() {
    print("engineStateChange");
   gearDoors (loopid)
}

setlistener("/fdm/jsbsim/propulsion/engine/set-running", engineStateChange);
gearDoors(loopid);