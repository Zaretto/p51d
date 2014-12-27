
# get smoothed climb rate data for property tree

# var rates = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
# var pos = -1;
# var total = 0.0;

# var climbRate = func {
    
  #  pos = pos + 1;
  #  if (pos > 9)
  #     pos = 0;
  #  if (rates[pos] != nil)
  #     total = total - rates[pos];
  #  rates[pos] = getprop("velocities/vertical-speed-fpm");
  #  if (rates[pos] != nil) {
  #     total = total + rates[pos];
  #     var avg=total/10;
  #     setprop("velocities/vertical-speed-fpm-smoothed", avg);
  #  }
  #  settimer(climbRate, 1.0);
#}

#climbRate();