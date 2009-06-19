var alt = props.globals.getNode("instrumentation/altimeter/pressure-alt-ft");
var boost = props.globals.getNode("controls/engines/engine[0]/boost");
var blower = props.globals.getNode("controls/engines/engine[0]/blower");
var lowblower = 0.51;

#### Set boost level
var main_loop = func {

	if (alt.getValue() > 17700 and blower.getValue() == 0 ) {
		interpolate (boost, 1,40);
		blower.setValue(1);
		}
	if (alt.getValue() < 17700 and blower.getValue() == 1 ) {
		interpolate (boost, lowblower,40);
		blower.setValue(0);
		}
  settimer(main_loop, 0.2)
}

setlistener("/sim/signals/fdm-initialized",main_loop);
