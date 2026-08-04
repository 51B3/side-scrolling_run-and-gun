extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _resume() -> void:
	# animation_player.play("")
	hide()
	
	get_tree().paused = false


func _pause() -> void:
	# animation_player.play("")
	show()
	
	get_tree().paused = true


func _on_resume_button_pressed() -> void:
	_resume()


func _on_restart_button_pressed() -> void:
	_resume()
	get_tree().reload_current_scene()


func _on_settings_button_pressed() -> void:
	$PanelContainer.hide()
	$settings.show()
	pass


func _on_main_menu_button_pressed() -> void:
	get_tree().quit()
