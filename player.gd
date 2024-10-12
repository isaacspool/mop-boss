extends RigidBody3D # like a class, gives access to all functions of rigid body

# RigidBody
@export var can_move: bool = true
@export var sprinting: bool = false

# Camera parameters
var default_mouse_mode = Input.MOUSE_MODE_CAPTURED
var pause_mouse_mode = Input.MOUSE_MODE_VISIBLE

# Player movement parameters
var walkspeed: float = 1200.0 # meters / second
var mouse_sensitivity := 0.001
var min_pitch := -60
var max_pitch := 60

var twist_input := 0.0
var pitch_input := 0.0

# Basically waitForChild()
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var player_pov := $TwistPivot/PitchPivot/PlayerPov

# Player inspect parameters
@onready var inspect_view = $"../InspectView"
@onready var inspected_node_holder = inspect_view.inspected_node_holder
@onready var inspector_gui = inspect_view.inspector_gui

var target: Node3D = null
@onready var highlight_object = inspect_view.highlight_object
@onready var inspected_node = inspect_view.inspected_node
@onready var inspect_group = inspect_view.inspect_group

@onready var character_height = $CollisionShape3D.shape.height

const max_jump_angle = 45
const min_dot_product =  cos(deg_to_rad(max_jump_angle))

# Adapted from https://forum.godotengine.org/t/how-to-check-if-rigid-body-is-on-floor/65679
"""Checks whether the player is on the floor or falling"""
func is_on_floor():
	# var raycast_result = Raycast.raycast_length(position, Vector3.DOWN, character_height/2, [self])
	# return raycast_result.has("collider")
	var state = PhysicsServer3D.body_get_direct_state(get_rid())
	var on_floor = false
	var i := 0
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		# The dot product is equal to cos of the desired angle (cos of 45 degrees = 0.7)
		on_floor = normal.dot(Vector3.UP) > min_dot_product #  1.0 UP / 0.0 SIDE / -1.0 DOWN 
		if on_floor: break 
		i += 1
	return on_floor

# Called when the node enters the scene tree for the **first time.**
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # sets default mouse to locked

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_move:
		var input := Vector3.ZERO # create blank vector3
		input.x = Input.get_axis("move_left", "move_right") # returns -1.0 if first, 0.0 if none
		input.z = Input.get_axis("move_forward", "move_back") # returns +1.0 if second, 0.0 if both
		
		if sprinting: input *= 1.25
		
		# twist_pivot to change movement relative to pivot of the rotated twist
		apply_central_force(twist_pivot.basis * input * 400.0 * delta * 50)
		
		# Pauses locking the mouse
		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(pause_mouse_mode)
		elif Input.is_action_just_released("ui_cancel"):
			Input.set_mouse_mode(default_mouse_mode)
		elif Input.is_action_just_pressed("jump") and is_on_floor():
			apply_central_impulse(Vector3(0, 6.5 * 50, 0))
		elif Input.is_action_just_pressed("sprint"):
			sprinting = true
		elif Input.is_action_just_released("sprint"):
			sprinting = false
			
		twist_pivot.rotate_y(twist_input)
		pitch_pivot.rotate_x(pitch_input)
		pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
			deg_to_rad(min_pitch),
			deg_to_rad(max_pitch))
		twist_input = 0.0
		pitch_input = 0.0
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Handle twist and pitch movement of camera
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
			
		## Handle raycasting for inspect and pickup of objects
		#var raycast_result: Dictionary = player_pov.raycast()
		## Check if there is the player has their mouse over an object
		#if raycast_result.has("collider"):
			#target = raycast_result.collider
		#else:
			#target = null
			#
		#if highlight_object != target:
			## Unhighlight old node
			#if highlight_object != null:
				#inspect_view._hide_outline(highlight_object)
			## Highlight new node
			#highlight_object = target
			## Handles whether if object should be highlighted
			#if (highlight_object is Node and highlight_object.is_in_group(inspect_group) 
			#and target.visible and inspected_node == null):
				#inspect_view._show_outline(highlight_object)
			#else:
				#highlight_object = null
	#elif event is InputEventMouseButton:
		#if highlight_object != null:
			#if not event.pressed and target is Node3D:
				## Start inspecting new node
				#inspector_gui.show()
				#inspected_node = target
				#var copy = inspect_view._set_up_inspected_copy(target.duplicate())
				#inspected_node_holder.add_child(copy)
				#target.hide()
	#elif event is InputEventKey:
		#if event.pressed: return
		#if event.keycode == KEY_ESCAPE:
			#if inspector_gui.visible:
				#inspect_view._close_inspector()
