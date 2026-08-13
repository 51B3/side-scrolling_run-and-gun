extends RigidBody2D
class_name Item


@onready var sprite: Sprite2D = $Sprite2D

@export var item_data: ItemData:
	set(value):
		if item_data == value:
			return
		
		item_data = value
		
		if is_node_ready():
			_draw()

"""
var is_equipped := false
"""


func _ready() -> void:
	if item_data == null:
		queue_free()
		
		return
	
	_draw()


func _draw() -> void: # Переименовать
	sprite.texture = item_data.texture


"""
func set_equipped(state: bool) -> void: # 
	is_equipped = state
	
	$interaction_area.monitoring = not state
	$interaction_area.monitorable = not state
	
	freeze = state
"""


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	"""
	if is_equipped:
		$hint.hide()
		
		return
	"""
	
	$hint.show()


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hint.visible = false
