io.include("Aircraft/ExpansionPack/Nasal/init.nas");

with("logger");

var max_distance_rocket = 10;
var max_distance_bomb = 50;

var max_message_distance = 100;

var hit_count_bullets = 0;
var hit_count_rockets = 0;
var hit_count_bombs = 0;

var callsign_bullets = "";
var callsign_rockets = "";
var callsign_bombs = "";

var hit_timer_bullets = 0;
var hit_timer_rockets = 0;
var hit_timer_bombs = 0;

var impact_types_bullets = [
    "left-gun-1-bullets",
    "left-gun-2-bullets",
    "left-gun-3-bullets",
    "right-gun-1-bullets",
    "right-gun-2-bullets",
    "right-gun-3-bullets",
];

var impact_types_rockets = [
    "fire-rocket-1",
    "fire-rocket-2",
    "fire-rocket-3",
    "fire-rocket-4",
    "fire-rocket-5",
    "fire-rocket-6",
    "fire-rocket-7",
    "fire-rocket-8",
    "fire-rocket-9",
    "fire-rocket-10",
];

var impact_types_bombs = [
    "drop-bomb-left",
    "drop-bomb-right",
];

var isBulletImpact = func (name) {
    foreach (type; impact_types_bullets) {
        if (type == name) {
            return 1;
        }
    }
    return 0;
};

var isRocketImpact = func (name) {
    foreach (type; impact_types_rockets) {
        if (type == name) {
            return 1;
        }
    }
    return 0;
};

var isBombImpact = func (name) {
    foreach (type; impact_types_bombs) {
        if (type == name) {
            return 1;
        }
    }
    return 0;
};

setlistener("/ai/models/model-impact", func (node) {
    var ballistic_name = node.getValue();
    var ballistic = props.globals.getNode(ballistic_name, 0);
    var closest_distance = 10000;
    var callsign = "";

    if (ballistic == nil) {
        return;
    }

    var typeNode  = ballistic.getNode("impact/type");
    var solidNode = ballistic.getNode("material/solid");
    var name = ballistic.getNode("name").getValue();

    if (typeNode == nil) {
        return;
    }

    var lat = ballistic.getNode("impact/latitude-deg").getValue();
    var lon = ballistic.getNode("impact/longitude-deg").getValue();
    var impactPos = geo.Coord.new().set_latlon(lat, lon);

    foreach (var mp; props.globals.getNode("/ai/models").getChildren("multiplayer")) {
        var mlat = mp.getNode("position/latitude-deg").getValue();
        var mlon = mp.getNode("position/longitude-deg").getValue();
        var malt = mp.getNode("position/altitude-ft").getValue() * FT2M;
        var selectionPos = geo.Coord.new().set_latlon(mlat, mlon, malt);
        var distance = impactPos.distance_to(selectionPos);

        if (distance < closest_distance) {
            closest_distance = distance;
            callsign = mp.getNode("callsign").getValue();
        }
    }

    if (callsign == "" or !solidNode.getBoolValue()) {
        return;
    }

    if (isBulletImpact(name)) {
        if (typeNode.getValue() != "terrain") {
            if (callsign == callsign_bullets) {
                hit_count_bullets += 1;
            }
            else {
                callsign_bullets = callsign;
                hit_count_bullets = 1;
            }

            if (hit_timer_bullets == 0) {
                hit_timer_bullets = 1;
                settimer(hitBullets, 1);
            }
        }
    }
    elsif (isRocketImpact(name)) {
        if (typeNode.getValue() != "terrain" or closest_distance < max_distance_rocket) {
            if (callsign == callsign_rockets) {
                hit_count_rockets += 1;
            }
            else {
                callsign_rockets = callsign;
                hit_count_rockets = 1;
            }

            if (hit_timer_rockets == 0) {
                hit_timer_rockets = 1;
                settimer(hitRockets, 1);
            }
        }
        elsif (closest_distance < max_message_distance) {
            logger.screen.red(sprintf("Missed %s by %d meters", callsign, closest_distance));
        }
    }
    elsif (isBombImpact(name)) {
        if (typeNode.getValue() != "terrain" or closest_distance < max_distance_bomb) {
            if (callsign == callsign_bombs) {
                hit_count_bombs += 1;
            }
            else {
                callsign_bombs = callsign;
                hit_count_bombs = 1;
            }

            if (hit_timer_bombs == 0) {
                hit_timer_bombs = 1;
                settimer(hitBombs, 1);
            }
        }
        elsif (closest_distance < max_message_distance) {
            logger.screen.red(sprintf("Missed %s by %d meters", callsign, closest_distance));
        }
    }
});

var hitBullets = func {
    message = "50 BMG hit: " ~ callsign_bullets ~ ": " ~ hit_count_bullets ~ " hits";

    hit_count_bullets = 0;
    callsign_bullets = "";

    defeatSpamFilter(message);
    hit_timer_bullets = 0;
};

var hitRockets = func {
    # HVAR warhead 7.5 lbs
    message = "HVAR hit: " ~ callsign_rockets ~ ": " ~ hit_count_rockets ~ " hits";

    hit_count_rockets = 0;
    callsign_rockets = "";

    defeatSpamFilter(message);
    hit_timer_rockets = 0;
};

var hitBombs = func {
    # 500 lbs bombs
    message = "GBU12 hit: " ~ callsign_bombs ~ ": " ~ hit_count_bombs ~ " hits";

    hit_count_bombs = 0;
    callsign_bombs = "";

    defeatSpamFilter(message);
    hit_timer_bombs = 0;
};

var spams = 0;
var spamList = [];

var defeatSpamFilter = func (str) {
  spams += 1;
  if (spams == 15) {
    spams = 1;
  }
  str = str~":";
  for (var i = 1; i <= spams; i+=1) {
    str = str~".";
  }
  var newList = [str];
  for (var i = 0; i < size(spamList); i += 1) {
    append(newList, spamList[i]);
  }
  spamList = newList;
}

var spamLoop = func {
  var spam = pop(spamList);
  if (spam != nil) {
    setprop("/sim/multiplay/chat", spam);
  }
}

var spamTimer = maketimer(1.20, spamLoop);
spamTimer.start();
