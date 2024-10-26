extends Puzzle


func is_altered() -> bool:
	return false


func is_solved() -> bool:
	return false


func on_enter_level() -> void:
	pass
	# TODO: pick random text or use:
# sudo code
# list of sentence structures: {"I saw the {noun} {verb} the {noun} the other day.}
# dictionary for nouns and verbs: {[noun: "dog", "cat"], [verb: "attacked", "hit"]}
# function loops for each key in dictionary checking if {key} in the randomly
# selected sentence structure, then replaces the first occurence, repeat till you
# have a random sentence.


func _on_puzzle_interact(_camera: Camera3D, event: InputEvent, _event_position: Vector3,
		_normal: Vector3, shape_idx: int, collision_object: CollisionObject3D) -> void:
	if not event is InputEventMouseButton: return
	if event.pressed: return # check for button released
	# TODO: erasing, ripping, and forging signatures