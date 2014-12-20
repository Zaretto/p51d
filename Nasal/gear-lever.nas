var state = getprop("/controls/gear/gear-down");

var gearLeverPos = func () {
  if (getprop("/controls/gear/gear-down") == 0) {
        state = 0;
        interpolate("/controls/gear/leverPos", 1.0, 2.0);
     }
  else if (getprop("/controls/gear/gear-down") == 1) {
        interpolate("/controls/gear/leverPos", 0.0, 2.0);
     }
}

setlistener("/controls/gear/gear-down", gearLeverPos, 0, 0);