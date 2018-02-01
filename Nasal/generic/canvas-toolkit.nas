# Copyright (C) 2017  onox
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

var create_check_box = func (root, name, property, enable_property = nil) {
    var check_box = canvas.gui.widgets.CheckBox.new(root, canvas.style, {})
      .setText(name)
      .setChecked(getprop(property))
      .listen("toggled", func (event) {
        setprop(property, event.detail.checked);
      });

    setlistener(property, func (node) {
        check_box.setChecked(node.getBoolValue());
    }, 1, 0);

    if (enable_property != nil) {
        setlistener(enable_property, func (node) {
            check_box.setEnabled(node.getBoolValue());
        }, 1, 0);
    }

    return check_box;
};

var create_button = func (root, name, callback, enable_property = nil) {
    var button = canvas.gui.widgets.Button.new(root, canvas.style, {})
      .setText(name)
      .listen("clicked", func {
        callback();
      });

    if (enable_property != nil) {
        setlistener(enable_property, func (node) {
            button.setEnabled(node.getBoolValue());
        }, 1, 0);
    }

    return button;
};

var create_group = func (root, name) {
    var label = canvas.gui.widgets.Label.new(root, canvas.style, {})
      .setText(name);

    var hbox = canvas.HBoxLayout.new();
    var vbox = canvas.VBoxLayout.new();

    hbox.addSpacing(12);
    hbox.addItem(vbox);

    var group_vbox = canvas.VBoxLayout.new();
    group_vbox.addItem(label);
    group_vbox.addItem(hbox);

    return [vbox, group_vbox];
};
