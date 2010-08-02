
# Logic to handle startup procedures

var primerTime = 0.0;

controls.startEngine = func(v = 1) {
    if (!v)
        setprop("fdm/jsbsim/systems/engine/starter", 0);
    else
        setprop("fdm/jsbsim/systems/engine/starter", 1);
}

var engageStarter = func {
    var starter = props.globals.getNode("controls/engines/engine/starter");
    if (starter == nil)
        screen.log.write("engageStarter getNode failed");
    if (getprop("fdm/jsbsim/systems/engine/engage-starter") == 0){
        starter.setBoolValue(0);
    }
    else {
        starter.setBoolValue(1);
    }
    settimer(engageStarter, 0.1);
}

settimer(engageStarter, 0.1);

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

setlistener("controls/engines/engine/primer-on", primer);