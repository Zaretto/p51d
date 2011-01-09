#
# Nasal script to open and close main gear inner doors based on engine running state and landing gear position.

var state = getprop("/controls/gear/gear-down");

var gearLeverPos = func () {
  if (state == 1 and getprop("/controls/gear/gear-down") == 0) {
        state = 0;
        interpolate("/controls/gear/leverPos", 1.0, 2.0);
     }
  if (state == 0 and getprop("/controls/gear/gear-down") == 1) {
        state = 1;
        interpolate("/controls/gear/leverPos", 0.0, 2.0);
     }
}

setlistener("/controls/gear/gear-down", gearLeverPos);