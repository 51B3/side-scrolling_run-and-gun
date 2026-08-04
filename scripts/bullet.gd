extends Node2D


var velocity: float


func _physics_process(delta: float) -> void:
	position += transform.x * velocity * delta


func _on_screen_exited() -> void:
	queue_free()


func _on_attack_area_body_entered(body: Node2D) -> void:	
	if body.is_in_group("zombie"):
		body.get_node("health_component").damage(10) # damage
		
		queue_free()
