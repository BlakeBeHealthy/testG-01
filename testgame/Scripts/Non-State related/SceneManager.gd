class_name SceneManager extends Node
# Called when the node enters the scene tree for the first time.

func load_level(scene_path: String) -> void:
	var holder = Gameplay.level_holder
	
	for child in holder.get_children():
		child.queue_free()

	var hold = load(scene_path)
	var new_level: Node = hold.instantiate()
	holder.add_child(new_level)
	Gameplay.on_level_loaded(new_level)
