extends CharacterBody2D


@export var speed: float = 128.0

var direction:       Vector2 = Vector2.ZERO
var target_velocity: Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	velocity = target_velocity
	
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hint.visible = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$hint.visible = false
