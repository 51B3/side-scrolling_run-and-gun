extends Control


signal item_dropped(item_data)

@onready var player: CharacterBody2D = get_tree().current_scene.get_node("player")

const ITEM_SCENE := preload("res://scenes/item.tscn")


func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	drop_item(data.item_data)
	data.clear_slot()


func drop_item(item_data: ItemData) -> void:
	var item_instance: Item = ITEM_SCENE.instantiate()
	
	item_instance.item_data = item_data
	
	get_tree().current_scene.add_child(item_instance)
	
	
	item_instance.global_position = player.global_position + Vector2(0, -16)
	
	await get_tree().physics_frame
	
	var direction: Vector2 = player.transform.x.normalized()
	
	item_instance.apply_impulse(direction * 250.0 + Vector2.UP * 100.0)
	item_dropped.emit(item_data)


func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_DRAG_BEGIN:
			mouse_filter = Control.MOUSE_FILTER_PASS
		Node.NOTIFICATION_DRAG_END:
			mouse_filter = Control.MOUSE_FILTER_IGNORE
