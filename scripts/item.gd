extends Node2D
class_name Item


@onready var sprite: Sprite2D = $Sprite2D

@export var stack:  int = 1 # 
@export var data:   ItemData:
	set(value):
		if data == value:
			return
		
		data = value
		
		if is_node_ready():
			update_visuals()

func _ready() -> void:
	if data == null:
		queue_free()
		
		return
	
	update_visuals()


func update_visuals() -> void: # Переименовать
	sprite.texture = data.texture


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	$hint.show()


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hint.visible = false
