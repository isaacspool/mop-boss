extends Area3D

var is_inspected := false

func _toggle_inspect(node: Node3D):
	if node == get_parent(): is_inspected = not is_inspected

func _on_input_event(_camera, event, _event_position, _normal, shape_idx):
	if not is_inspected: return
	if not event is InputEventMouseButton: return
	if event.pressed: return # check for button released
	var radians := TAU/10 # TAU is 2 * PI
	match event.button_index: # this is comaring the button index to everything in the match statement
		MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_RIGHT:
			radians *= -1
	get_child(shape_idx).rotate_x(radians)


# setup function : give it random color, code, etc

# puzzle function : activates when inspect mode

# check state function : checks state of object and updates to either altered or unaltered
