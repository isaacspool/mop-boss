extends RigidBody3D


var is_inspected := false


func setup():
	$Lock.get_surface_override_material(0).albedo_color = Color(randf() / 5.0, randf() / 5.0, randf() / 5.0, 1.0)
