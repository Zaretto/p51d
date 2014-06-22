
# Logic to handle rockets, bombs and drop tanks

var loopid = 0;
var salvoCount = 1;
var triggerLast = 0;
var triggerDown = 0;
var lastRX = 1;
var bombCount = 0;
var rocketsStart = 12;
var bombsStart = 22;
var tanksStart = 24;

var resetRocketTriggers = func() {

    for (i=1; i < 11; i = i + 1)
       setprop("/controls/armament/rocket[" ~ i ~ "]/trigger", 0.0);
}

var rocketSalvo = func(id){
    
    id == loopid or return;
    setprop("/controls/armament/rocket[" ~ salvoCount ~ "]/trigger", 1.0);
    salvoCount = salvoCount + 1;
    if (salvoCount > 11) {
       setprop("/controls/armament/rocket-salvo", 0.0);
       resetRocketTriggers();
       salvoCount = 1;
       loopid += 1;
    }
    settimer(func{rocketSalvo(id)}, 0.1);
}

var fireSingleRocket = func(){
    
   lastRX = getprop("/controls/armament/next-RX");
   setprop("/controls/armament/rocket[" ~ lastRX ~ "]/trigger", 1);
}


var trigger2 = func {

    triggerDown = getprop("/controls/armament/trigger2");

    if (getprop("/controls/armament/rockets") == 1 and
        getprop("/controls/armament/rocket-controler") > 0) {
        if (getprop("/controls/armament/rocket-controler") == 2)
            rocketSalvo(loopid);
        else if (getprop("/controls/armament/trigger2") == 1)
               fireSingleRocket();
   }
   triggerLast = getprop("/controls/armament/trigger2");
}

setlistener("/controls/armament/trigger2", trigger2);

var setStores = func(stores) {
   setprop("/controls/armament/User-Selected-Stores", stores);
   # no external stores
   if (stores == 0) {
      # rockets
      for (i=rocketsStart; i < bombsStart; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=bombsStart; i < tanksStart; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # tanks
      for (i=tanksStart; i < tanksStart + 2; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      setprop("consumables/fuel/tank[3]/level-gal_us", 0);
      setprop("consumables/fuel/tank[4]/level-gal_us", 0);
   }
   # bombs only
   if (stores == 1) {
      # rockets
      for (i=rocketsStart; i < bombsStart; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=bombsStart; i < tanksStart; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      # tanks
      for (i=tanksStart; i < tanksStart + 2; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      setprop("consumables/fuel/tank[3]/level-gal_us", 0);
      setprop("consumables/fuel/tank[4]/level-gal_us", 0);
   }
   # rockets only
   if (stores == 2) {
      # rockets
      for (i=rocketsStart; i < bombsStart; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      resetRocketTriggers();
      # bombs
      for (i=bombsStart; i < tanksStart; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # tanks
      for (i=tanksStart; i < tanksStart + 2; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      setprop("consumables/fuel/tank[3]/level-gal_us", 0);
      setprop("consumables/fuel/tank[4]/level-gal_us", 0);
   }
   # rockets and bombs
   if (stores == 3) {
      # rockets
      resetRocketTriggers();
      for (i = rocketsStart; i < rocketsStart + 7; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      for (i=rocketsStart + 6; i < bombsStart; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=bombsStart; i < tanksStart; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      # tanks
      for (i=tanksStart; i < tanksStart + 2; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      setprop("consumables/fuel/tank[3]/level-gal_us", 0);
      setprop("consumables/fuel/tank[4]/level-gal_us", 0);
   }
   # tanks only
   if (stores == 4) {
      # rockets
      for (i=rocketsStart; i < bombsStart; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=bombsStart; i < tanksStart; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # tanks
      for (i=tanksStart; i < tanksStart + 2; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      setprop("consumables/fuel/tank[3]/level-gal_us", 75);
      setprop("consumables/fuel/tank[4]/level-gal_us", 75);
      setprop("/controls/armament/drop-tank-released-1", 0);
      setprop("/controls/armament/drop-tank-released-2", 0);
   }
   # rocket and tanks
   if (stores == 5) {
      # rockets
      resetRocketTriggers();
      for (i = rocketsStart; i < rocketsStart + 7; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      for (i=rocketsStart + 6; i < bombsStart; i = i + 1) 
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=bombsStart; i < tanksStart; i = i + 1) 
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # tanks
      for (i=tanksStart; i < tanksStart + 2; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      setprop("consumables/fuel/tank[3]/level-gal_us", 75);
      setprop("consumables/fuel/tank[4]/level-gal_us", 75);
      setprop("/controls/armament/drop-tank-released-1", 0);
      setprop("/controls/armament/drop-tank-released-2", 0);
   }
}

var loadGuns = func (load) {
   var tracerStart = 0;
   var bulletsStart = 6;
   var smokeStart = 26;
   if (load == 0) {
      for (i=tracerStart; i < rocketsStart; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
   }
   else {
      for (i=tracerStart; i < tracerStart + 2; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 80);
      for (i=tracerStart + 2; i < bulletsStart; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 54);
      for (i= bulletsStart; i < bulletsStart + 2; i = i + 1) 
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 320);
      for (i=bulletsStart + 2; i < bulletsStart + 6; i = i + 1) 
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 216);
      for (i= smokeStart; i < smokeStart + 2; i = i + 1) 
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 400);
      for (i=smokeStart + 2; i < smokeStart + 6; i = i + 1) 
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 270);
   }
}

var L = setlistener("/sim/signals/fdm-initialized",
                     func {
                        setStores(0);
                        setprop("/controls/armament/salvo-count", 1);
                        resetRocketTriggers();
                        removelistener(L);
                     }
);
