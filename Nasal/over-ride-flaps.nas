# Over ride default controls.flapsDown
# Hard-coded flaps movement in 5 steps, 10, 20, 30, 40 and 50 degrees:
# --------------------------------------------------------
controls.flapsDown = func {
        if(arg[0] == 0) { return; }
        if(props.globals.getNode("/sim/flaps") != nil) {
                stepProps("/controls/flight/flaps", "/sim/flaps", arg[0]);
                return;
        }
        current_f = getprop("/controls/flight/flaps");
        if (arg[0] == 1) {
                if (current_f == 1) {
                        return;
                } elsif (current_f == 0) {
                        setprop("/controls/flight/flaps", 0.2);
                } elsif (current_f == 0.2) {
                        setprop("/controls/flight/flaps", 0.4);
                } elsif (current_f == 0.4) {
                        setprop("/controls/flight/flaps", 0.6);
                } elsif (current_f == 0.6) {
                        setprop("/controls/flight/flaps", 0.8);
                } else {
                        setprop("/controls/flight/flaps", 1);
                }
        } else {
                if (current_f == 0) {
                        return;
                } elsif (current_f == 0.2) {
                        setprop("/controls/flight/flaps", 0);
                } elsif (current_f == 0.4) {
                        setprop("/controls/flight/flaps", 0.2);
                } elsif (current_f == 0.6) {
                        setprop("/controls/flight/flaps", 0.4);
                } elsif (current_f == 0.8) {
                        setprop("/controls/flight/flaps", 0.6);
                } else {
                        setprop("/controls/flight/flaps", 0.8);
                }
        }
}