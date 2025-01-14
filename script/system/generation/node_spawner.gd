class_name NodeSpawner
extends Node3D

var spawned_node: Node3D = null

const empty_tag = "empty_spawner"
const full_tag = "full_spawner"

signal on_spawn_node(node: Node3D)

func _ready():
	$EditorMarker.queue_free()

func spawn_random():
	#if self.get_child_count() > 0: await(NodeHelper.destroy_children(self.get_children())) #self.get_child(0).free() #NodeHelper.destroy_children(self.get_children())
	#var categories = self.get_children().filter(func(child): return child is Category)
	var random = G_node.random_child_weighted(self)
	random = random.pick_node()
	if random == null: return
	
	var new_spawned_node = spawn(random)
	spawned_node = new_spawned_node
	on_spawn_node.emit(spawned_node)
	return new_spawned_node

func spawn(scene: PackedScene):
	if spawned_node != null: return
	
	self.remove_from_group(empty_tag)
	self.add_to_group(full_tag)
	
	spawned_node = scene.instantiate()
	if spawned_node.has_method("on_enter_level"): spawned_node.on_enter_level()
	add_child(spawned_node)
	on_spawn_node.emit(spawned_node)
	return spawned_node

func despawn():
	if spawned_node == null: return
	
	self.remove_from_group(full_tag)
	self.add_to_group(empty_tag)
	
	spawned_node.free()
