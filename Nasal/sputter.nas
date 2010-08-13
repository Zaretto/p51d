var currentTank = 0;
var sputterLevel = 6.0;  # pounds of fuel
var sputtering = 0;

var engineSputter = func {
   var timer = rand() * 3;
   var eng_off = func {
      setprop("/engines/engine[0]/running", 0);
      setprop("/engines/engine[0]/out-of-fuel", 1);
      sputtering = 1;
   };

   if (getprop("/consumables/fuel/tank[" ~ currentTank ~ "]/level-lbs") < sputterLevel)
       settimer(eng_off, timer + 0.5);
   
   var eng_on = func {
      setprop("/engines/engine[0]/running", 1);
      setprop("/engines/engine[0]/out-of-fuel", 0);
      sputtering = 0;
   };

   if (getprop("/consumables/fuel/tank[" ~ currentTank ~ "]/level-lbs") < sputterLevel)
      settimer(eng_on, timer + 2.5);
   else 
      eng_on();
}

var checkTankLow = func () {
   currentTank = getprop("/fdm/jsbsim/propulsion/current_feed_tank");
   var curLevel = getprop("/consumables/fuel/tank[" ~ currentTank ~ "]/level-lbs");
   
   # sputtering will start with more fuel in the tank at higher power settings.
   # This should give about 4.5 seconds of sputtering at 67 inHg
   var MP = getprop("/engines/engine/mp-inhg");
   # the nil check is needed to prevent a runtime error at start up
   if (MP == nil)  
       sputterLevel = 6.0;
   else
       sputterLevel = 6.0 + 6.0 * ((MP - 10)/57);
   
   if(curLevel < sputterLevel and !sputtering){
      engineSputter();
   }
   settimer(checkTankLow, 1.0);
}

checkTankLow();