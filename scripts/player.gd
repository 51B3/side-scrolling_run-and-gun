extends CharacterBody2D


var direction: Vector2 = Vector2.ZERO
var walk_speed: float = 128.0
var sprint_speed: float = 192.0
var target_velocity: Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	direction = Vector2.ZERO
	
	var current_speed: float = walk_speed
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		# $AnimationPlayer.play("")
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		# $AnimationPlayer.play("")
	
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		# $AnimationPlayer.play("")
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		# $AnimationPlayer.play("")
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		
		if Input.is_action_pressed("sprint"):
			current_speed = sprint_speed
	
	target_velocity.x = direction.x * current_speed
	target_velocity.y = direction.y * current_speed
	position.y = clamp(position.y, 250, 450) # Bounds
	velocity = target_velocity
	
	move_and_slide()


func _on_interaction_area_body_entered(_body: Node2D) -> void:
	pass


func _on_interaction_area_body_exited(_body: Node2D) -> void:
	pass
