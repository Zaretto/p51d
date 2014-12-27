#
# Nasal script to open and close main gear inner doors based on engine running state and landing gear position.

var engineStateChanging = 0;
var direction = 1;
var pos = 1;

setprop("/fdm/jsbsim/systems/gear/direction", "down");

var changeState = func {
    engineStateChanging = 0;   
} 

var initGearDoorPos = func {
   setprop("/fdm/jsbsim/systems/gear/inner-doors", 1.0);   # doors open
}

var engineGearDoorPos = func() {
  if (getprop("gear/gear[0]/position-norm") > 0.99) {
     engineStateChanging = 1;
     # engine just started and gear is down
     if (getprop("engines/engine[0]/running") > 0.99) {   
       interpolate("/fdm/jsbsim/systems/gear/inner-doors", 0.0, 4.0);
     }
     # engine just stopped and gear down
     else if (getprop("engines/engine[0]/running") < 0.01) {
       interpolate("/fdm/jsbsim/systems/gear/inner-doors", 1.0, 4.0);
     }
     settimer(changeState, 4.0);
   }
}


initGearDoorPos();
setlistener("/engines/engine[0]/running", engineGearDoorPos, 0, 0);

var gearPos = func () {
  if (pos == 1 and getprop("gear/gear[0]/position-norm") > 0.9999) {
     pos = 0;
     direction = 0;
  }
  else if (pos == 0 and getprop("gear/gear[0]/position-norm") < 0.0001){
     pos = 0;
     direction = 0;
  }
  setprop("/fdm/jsbsim/systems/gear/direction", direction);
  if (getprop("engines/engine[0]/running") > 0.99 and engineStateChanging == 0) {
    if (getprop("gear/gear[0]/position-norm") < 0.33333333333) 
      pos = getprop("gear/gear[0]/position-norm") * 3;
    if (getprop("gear/gear[0]/position-norm") >= 0.33333333333 and getprop("gear/gear[0]/position-norm") < 0.666666) 
      pos = 1.0;
    if (getprop("gear/gear[0]/position-norm") >= 0.666666)
      pos = ( 1 - getprop("gear/gear[0]/position-norm")) * 3.0;
    setprop("/fdm/jsbsim/systems/gear/inner-doors", pos);
  }
}

setlistener("/gear/gear[0]/position-norm", gearPos, 0, 0);
