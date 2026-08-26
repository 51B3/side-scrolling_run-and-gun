extends CharacterBody2D


var direction:         Vector2 = Vector2.ZERO
var walk_speed:        float = 108.0
var sprint_speed:      float = 192.0
var target_velocity:   Vector2 = Vector2.ZERO
var can_interact_with: Dictionary[String, Array] = {
	"item": [],
	"NPC": [],
	"chest": [],
	"pushable": [], # (?)
	"trigger": []
}
var can_attack:        Dictionary[String, Array] = {
	"enemy": [],
	"pushable": [],
	"NPC": [],
	"environment": []
}


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


func _on_interaction_area_body_entered(body: Node2D) -> void:
	for group in body.get_groups():
		if group in can_interact_with:
			if body is Item and \
			body.is_equipped:
				return
			
			if not body in can_interact_with[group]:
				can_interact_with[group].append(body)


func _on_interaction_area_body_exited(body: Node2D) -> void:
	for group in body.get_groups():
		if group in can_interact_with:
			if body is Item and \
			body.is_equipped:
				return
			
			if body in can_interact_with[group]:
				can_interact_with[group].erase(body)


func _on_interaction_area_entered(area: Area2D) -> void:
	for group in area.get_groups():
		if group in can_interact_with:
			if not area in can_interact_with[group]:
				can_interact_with[group].append(area)


func _on_interaction_area_exited(area: Area2D) -> void:
	for group in area.get_groups():
		if group in can_interact_with:
			if area in can_interact_with[group]:
				can_interact_with[group].erase(area)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if not body.has_node("health_component"):
		return
	
	for group in body.get_groups():
		if group in can_attack:
			if body not in can_attack[group]:
				can_attack[group].append(body)


func _on_attack_area_body_exited(body: Node2D) -> void:
	if not body.has_node("health_component"):
		return
	
	for group in body.get_groups():
		if group in can_attack:
			if body in can_attack[group]:
				can_attack[group].erase(body)
