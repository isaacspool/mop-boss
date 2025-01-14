extends Node

func raycast_to(origin: Vector3, end: Vector3, exclude: Array = []):
	var current_scene = get_tree().current_scene
	var space_state = current_scene.get_world_3d().direct_space_state

	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	query.exclude = exclude

	var result = space_state.intersect_ray(query)
	return result

func raycast_length(origin: Vector3, direction: Vector3, ray_length: float = 1000, exclude: Array = []):
	var end = origin + direction * ray_length
	return raycast_to(origin, end, exclude)

func raycast_mouse(camera: Camera3D, ray_length: float = 1000, exclude: Array = []):
	var mousepos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * ray_length
	return raycast_to(origin, end, exclude)

"""Gets the object the player's mouse is targetting, or null if not targetting anything with a collider."""
func get_mouse_target(camera: Camera3D, exclude: Array = []):
	var raycast_result: Dictionary = raycast_mouse(camera, 1000, exclude)
	var target = null
	if raycast_result.has("collider"):
		target = raycast_result.collider
	return target
