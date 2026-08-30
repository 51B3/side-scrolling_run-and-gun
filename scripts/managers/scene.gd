extends Node


func change_scene_with_loading(path: String) -> void: # Rename?
	var loading_screen = preload("res://scenes/UI/loading_screen.tscn").instantiate()
	
	get_tree().root.add_child(loading_screen)
	loading_screen.scene_loaded.connect(_on_scene_loaded.bind(loading_screen))
	loading_screen.load_scene(path)


func _on_scene_loaded(loaded_scene: PackedScene, loading_screen: Control) -> void:
	loading_screen.queue_free()
	
	var error = get_tree().change_scene_to_packed(loaded_scene)
	
	if error != OK:
		push_error("Failed to change scene: " + str(error))
