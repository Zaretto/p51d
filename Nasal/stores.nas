
# Logic to handle rockets, bombs and drop tanks

var loopid = 0;
var salvoCount = 1;
var triggerLast = 0;
var triggerDown = 0;
var lastRX = 1;
var bombCount = 0;

var resetRocketTriggers = func() {

    for (i=1; i < 11; i = i + 1)
       setprop("controls/armament/rocket[" ~ i ~ "]/trigger", 0.0);
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
    
   lastRX = getprop("controls/armament/next-RX");
   setprop("/controls/armament/rocket[" ~ lastRX ~ "]/trigger", 1);
}

var bombsBoth = func() {

    if (getprop("controls/armament/User-Selected-Stores") == 1 or
        getprop("controls/armament/User-Selected-Stores") == 3) {
        setprop("controls/armament/bomb-trigger-1", getprop("controls/armament/trigger2"));
        setprop("controls/armament/bomb-trigger-2", getprop("controls/armament/trigger2"));      }
    else {
        setprop("controls/armament/drop-tank-release-1", getprop("controls/armament/trigger2"));
        setprop("controls/armament/drop-tank-release-2", getprop("controls/armament/trigger2"));
    }
}

var bombsTrain = func {
    
    if (getprop("controls/armament/User-Selected-Stores") == 1 or
        getprop("controls/armament/User-Selected-Stores") == 3) {
        if (getprop("ai/submodels/submodel[18]/count") == 1)
           setprop("controls/armament/bomb-trigger-1", 1);
        else
           setprop("controls/armament/bomb-trigger-2", 1.0);
    }
    else {
        if (getprop("ai/submodels/submodel[20]/count") == 1)
           setprop("controls/armament/drop-tank-release-1", 1.0);
        else
            setprop("controls/armament/drop-tank-release-2", 1.0);
    }
}

var trigger2 = func {

    triggerDown = getprop("controls/armament/trigger2");

    if (getprop("/controls/armament/bombs-both") == 1) {
       bombsBoth();
    }
    if (getprop("/controls/armament/bombs-train") == 1) {
        if (getprop("controls/armament/trigger2") > 0) {
               bombsTrain();
           }
           else {
              setprop("/controls/armament/bomb-trigger-1", 0.0);
              setprop("/controls/armament/bomb-trigger-2", 0.0);
              setprop("/controls/armament/drop-tank-release-1", 0.0);
              setprop("/controls/armament/drop-tank-release-1", 0.0);
           }
    }
    if (getprop("/controls/armament/rockets") == 1 and
        getprop("/controls/armament/rocket-controler") > 0) {
        if (getprop("/controls/armament/rocket-controler") == 2)
            rocketSalvo(loopid);
        else if (getprop("controls/armament/trigger2") > 0)
               fireSingleRocket();
   }
   triggerLast = getprop("controls/armament/trigger2");
}

setlistener("controls/armament/trigger2", trigger2);

var setStores = func(stores) {
   print("setStores");
   setprop("/controls/armament/User-Selected-Stores", stores);
   if (stores == 0) {
      # rockets
      for (i=8; i < 18; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=18; i < 20; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # tanks
      for (i=20; i < 22; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      setprop("consumables/fuel/tank[3]/level-gal_us", 0);
      setprop("consumables/fuel/tank[4]/level-gal_us", 0);
   }
   if (stores == 1) {
      # rockets
      for (i=8; i < 18; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=18; i < 20; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      # tanks
      for (i=20; i < 22; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      setprop("consumables/fuel/tank[3]/level-gal_us", 0);
      setprop("consumables/fuel/tank[4]/level-gal_us", 0);
   }
   if (stores == 2) {
      # rockets
      for (i=8; i < 18; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      resetRocketTriggers();
      # bombs
      for (i=18; i < 20; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # tanks
      for (i=20; i < 22; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      setprop("consumables/fuel/tank[3]/level-gal_us", 0);
      setprop("consumables/fuel/tank[4]/level-gal_us", 0);
   }
   if (stores == 3) {
      # rockets
      resetRocketTriggers();
      for (i=8; i < 14; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      for (i=14; i < 18; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=18; i < 20; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      # tanks
      for (i=20; i < 22; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      setprop("consumables/fuel/tank[3]/level-gal_us", 0);
      setprop("consumables/fuel/tank[4]/level-gal_us", 0);
   }
   if (stores == 4) {
      # rockets
      for (i=8; i < 18; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=18; i < 20; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # tanks
      for (i=20; i < 22; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      setprop("consumables/fuel/tank[3]/level-gal_us", 75);
      setprop("consumables/fuel/tank[4]/level-gal_us", 75);
   }
   if (stores == 5) {
      # rockets
      resetRocketTriggers();
      for (i=8; i < 14; i = i + 1)
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      for (i=14; i < 18; i = i + 1) 
        setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # bombs
      for (i=18; i < 20; i = i + 1) 
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
      # tanks
      for (i=20; i < 22; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 1);
      setprop("consumables/fuel/tank[3]/level-gal_us", 75);
      setprop("consumables/fuel/tank[4]/level-gal_us", 75);
   }
}

var loadGuns = func (load) {
   print("loadGuns");
   if (load == 0) {
      for (i=0; i < 8; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 0);
   }
   else {
      for (i=0; i < 2; i = i + 1)
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 300);
      for (i=2; i < 4; i = i + 1) 
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 400);
      for (i=4; i < 7; i = i + 1) 
           setprop("ai/submodels/submodel[" ~ i ~ "]/count", 270);
   }
}

var FillWingTanks = func () {
    setprop("consumables/fuel/tank[0]/level-gal_us", 92);
    setprop("consumables/fuel/tank[1]/level-gal_us", 92);
}

var FillFuseTank = func () {
    setprop("consumables/fuel/tank[2]/level-gal_us", 85);
}

var L = setlistener("/sim/signals/fdm-initialized",
                     func {
                        fuel_dialog = gui.Dialog.new("/sim/gui/dialogs/P-51D/fuel/dialog","Aircraft/p51d/Dialogs/P-51D-Fuel.xml");
                        setStores(0);
                        setprop("/controls/armament/salvo-count", 1);
                        resetRocketTriggers();
                        removelistener(L);
                     }
);
