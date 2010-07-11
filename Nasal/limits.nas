#
# Nasal script to print errors to the screen when aircraft exceed design limits:
#  - extending flaps above maximum flap extension speed(s)
#  - extending gear above maximum gear extension speed
#  - exceeding Vna
#  - exceeding structural G limits

var checkFlaps = func(n) {

    var flapsetting = n.getValue();
    if (flapsetting == 0)
        return;


    var airspeed = getprop("velocities/airspeed-kt");

    if ((flapsetting < 0.35 and airspeed > 347.6) or
        (flapsetting > 0.35 and flapsetting < 0.55 and airspeed > 239) or
        (flapsetting > 0.55 and flapsetting < 0.75 and airspeed > 195.5) or
        (flapsetting > 0.75 and flapsetting < 0.95 and airspeed > 156.4) or
        (flapsetting > 0.95 and airspeed > 143.4)) {
            screen.log.write("Flaps extended above maximum flap extension speed!");
        }
    # cause structural damage when safe speed is exceeded by 10%
    if ((flapsetting < 0.35 and airspeed > 381.7) or
        (flapsetting > 0.35 and flapsetting < 0.55 and airspeed > 263) or
        (flapsetting > 0.55 and flapsetting < 0.75 and airspeed > 214.5) or
        (flapsetting > 0.75 and flapsetting < 0.95 and airspeed > 172) or
        (flapsetting > 0.95 and airspeed > 157.7)) {
            screen.log.write("Flaps damaged!");
            setprop("/sim/failute-manager/controls/flaps/serviceable", 0);
        }
}


var checkGear = func(n) {

    if (!n.getValue())
        return;

    if (getprop("velocities/airspeed-kt") > 147.7) {
        screen.log.write("Gear extended above maximum extension speed!");
    }
}


# ====== Structural failure load limt exceeded =======
# This only prints a message actual failure is handled
# by Systems/crash-detect.xml

var checkG = func (n) {

    if (getprop("/sim/freeze/replay-state"))
       return;

    var overG = n.getValue();

    if (overG > 0){
        if (getprop("/fdm/jsbsim/accelerations/Nz") > 0) {
            msg = "Airframe structural positive load limit exceeded!";
        }
        else {
            msg = "Airframe structural negative load limit exceeded!";
        }
        screen.log.write(msg);
    }
}

# Set the listeners
setlistener("controls/flight/flaps", checkFlaps);
setlistener("controls/gear/gear-down", checkGear);
setlistener("fdm/jsbsim/systems/crash-detect/over-g", checkG);

# ====== VNE exceeded =======

var VNETime = 0;
var VNETimePlus = 0;

var checkVNE = func {

    if (getprop("/sim/freeze/replay-state"))
    return;

    if ((getprop("instrumentation/airspeed-indicator/indicated-airspeed") != nil) and
      (getprop("instrumentation/airspeed-indicator/indicated-airspeed") > 439)) {
        if (VNETime == 0)
           screen.log.write("Airspeed exceeds Vne!");        
        if (getprop("instrumentation/airspeed-indicator/indicated-airspeed") > 483) {
            # elevator fails after 2 seconds above VNE + 10%
            if (VNETime == 4) {
                screen.log.write("Elevator Failure");
                setprop("/sim/failute-manager/controls/elevator/serviceable", 0);
            }
            # rudder fails after 3 seconds above VNE + 10%
            if (VNETime == 6) {
                screen.log.write("Rudder Failure");
                setprop("/sim/failute-manager/controls/rudder/serviceable", 0);
            }
            # ailerons fails after 4 seconds above VNE + 10%
            if (VNETime == 8) {
                screen.log.write("Rudder Failure");
                setprop("/sim/failute-manager/controls/aileron/serviceable", 0);
            }
            # complete structural failure after 5 seconds above VNE + 10%
            if (VNETime > 10) {
                screen.log.write("Structural Failure");
                setptop("/fdm/jsbsim/systems/crash-detect/crashed", 1);
            }
            VNETimePlus = VNETimePlus + 1;
        }
        else {
            VNETimePlus = 0;
            VNETime = VNETime + 1;
        }
    }
    else {
        VNETimePlus = 0;
        VNETime = 0;
    }
    settimer(checkVNE, 0.5);
}

checkVNE();

