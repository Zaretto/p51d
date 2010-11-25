#
# Nasal script to open and close main gear inner doors based on engine running state and landing gear position.

var pos = 0;
var loopid = 0;
var running = 0;
var init=1;
var state = 1;

var changeState = func {
    state = 1; 
} 

var initGearDoorPos = func {
   setprop("/fdm/jsbsim/systems/gear/inner-doors", 1.0);   # doors open
}

var engineGearDoorPos = func() {
  # engine just started and gear is down
  if (getprop("engines/engine[0]/running") > 0.99 and 
      getprop("gear/gear[0]/position-norm") > 0.99) { 
    state = 0;        
    interpolate("/fdm/jsbsim/systems/gear/inner-doors", 0.0, 4.0);
    settimer(changeState, 4.0, 1);
  }
  # engine just stopped and gear down
  if (getprop("engines/engine[0]/running") < 0.01 and 
      getprop("gear/gear[0]/position-norm") > 0.99) {
    interpolate("/fdm/jsbsim/systems/gear/inner-doors", 1.0, 4.0);
    state = 1;
  }
}


initGearDoorPos();
setlistener("/engines/engine[0]/running", engineGearDoorPos);

var gearPos = func () {
  if (getprop("engines/engine[0]/running") > 0.99 and state == 1) {
    if (getprop("gear/gear[0]/position-norm") < 0.33333333333) 
      pos = getprop("gear/gear[0]/position-norm") * 3;
    if (getprop("gear/gear[0]/position-norm") >= 0.33333333333 and getprop("gear/gear[0]/position-norm") < 0.666666) 
      pos = 1.0;
    if (getprop("gear/gear[0]/position-norm") >= 0.666666)
      pos = ( 1 - getprop("gear/gear[0]/position-norm")) * 3.0;
    setprop("/fdm/jsbsim/systems/gear/inner-doors", pos);
  }
}

setlistener("/gear/gear[0]/position-norm", gearPos);
