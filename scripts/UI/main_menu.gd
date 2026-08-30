extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_play_button_pressed() -> void:
	SceneManager.change_scene_with_loading("res://scenes/world.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
