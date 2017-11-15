var add_content = func (root) {
    var vbox = canvas.VBoxLayout.new();

    var (group1, group1_vbox) = gui.create_group(root, "Rendering");
    var (group2, group2_vbox) = gui.create_group(root, "Combat");
    var (group3, group3_vbox) = gui.create_group(root, "Securing");

    group1.addItem(gui.create_check_box(root, "Show pilot in Cockpit View", "/aircraft/pilot/always-visible"));
    group1.addItem(gui.create_check_box(root, "Always show propeller blades", "/aircraft/settings/show-blades"));

    group2.addItem(gui.create_button(root, "Repair damage", func {
        p51d.repair_damage();
    }, "/aircraft/gui/can-repair"));

    group3.addItem(gui.create_check_box(root, "Add cover to pitot tube", "/aircraft/securing/pitot-cover-visible", "/gear/on-ground-at-rest"));
    group3.addItem(gui.create_check_box(root, "Add tie-down to left wing", "/aircraft/securing/left-tiedown-visible", "/gear/on-ground-at-rest"));
    group3.addItem(gui.create_check_box(root, "Add tie-down to right wing", "/aircraft/securing/right-tiedown-visible", "/gear/on-ground-at-rest"));
    group3.addItem(gui.create_check_box(root, "Add tie-down to left part of tail", "/aircraft/securing/tail-left-tiedown-visible", "/gear/on-ground-at-rest"));
    group3.addItem(gui.create_check_box(root, "Add tie-down to right part of tail", "/aircraft/securing/tail-right-tiedown-visible", "/gear/on-ground-at-rest"));

    vbox.addItem(group1_vbox);
    vbox.addItem(group2_vbox);
    vbox.addItem(group3_vbox);

    return vbox;
};

var add_dialog_buttons = func (root, window, hbox) {
    hbox.addItem(gui.create_button(root, "Close", func {
        window.del();
    }));
};

var pixel_size = [250, 350];
var title = "Aircraft Options";

var show_aircraft_options = func {
    var window = canvas.Window.new(pixel_size, "dialog")
      .set('title', title);

    window.del = func {
        call(canvas.Window.del, [], me);
    };

    window.getCanvas(1).set("background", canvas.style.getColor("bg_color"));
    var root = window.getCanvas(1).createGroup();

    var root_vbox = canvas.VBoxLayout.new();
    window.setLayout(root_vbox);

    # Dialog buttons in the bottom right corner of the window
    var dialog_button_box = canvas.HBoxLayout.new();
    dialog_button_box.addStretch(1);
    add_dialog_buttons(root, window, dialog_button_box);

    # Content + dialog buttons at the bottom
    root_vbox.setContentsMargin(6);
    root_vbox.addItem(add_content(root));
    root_vbox.addStretch(1);
    root_vbox.addItem(dialog_button_box);
}
