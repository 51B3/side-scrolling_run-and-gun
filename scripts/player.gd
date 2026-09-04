extends CharacterBody2D


@onready var ui_manager: CanvasLayer = $"../CanvasLayer"

var direction:         Vector2 = Vector2.ZERO
var walk_speed:        float = 108.0
var sprint_speed:      float = 192.0
var target_velocity:   Vector2 = Vector2.ZERO
var can_interact_with: Dictionary[String, Array] = {
	"item": [],
	"NPC": [],
	"trigger": []
}
var can_attack:        Dictionary[String, Array] = {
	"enemy": [],
	"pushable": [],
	"NPC": [],
	"environment": []
}


func _process(_delta: float) -> void:
	if ui_manager.pause_menu.visible:
		return
	
	if Input.is_action_just_pressed("interact"):
		if can_interact_with["item"].size() > 0:
			var item: Item = _get_closest("item", true)
			
			if item.data is AmmoData:
				get_node("%ammo_component").add(item.data, item.stack) # 
			
			can_interact_with["item"].erase(item)
			item.queue_free()
		
		if can_interact_with["NPC"].size() > 0:
			pass
		
		if can_interact_with["trigger"].size() > 0:
			pass


func _get_closest(group: String, is_interactable: bool) -> Node: # Rename
	var min_distance = INF
	var closest = null
	
	for entity in can_interact_with[group] if is_interactable else can_attack[group]:
		var distance = global_position.distance_to(entity.global_position)
		
		if distance < min_distance:
			min_distance = distance
			closest = entity
	
	return closest


func _physics_process(_delta: float) -> void:
	direction = Vector2.ZERO
	
	var current_speed: float = walk_speed
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		
		"""
		$AnimationPlayer.play("")
		"""
	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
		"""
		$AnimationPlayer.play("")
		"""
	
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		
		"""
		$AnimationPlayer.play("")
		"""
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		
		"""
		$AnimationPlayer.play("")
		"""
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		
		if Input.is_action_pressed("sprint"):
			current_speed = sprint_speed
	
	target_velocity.x = direction.x * current_speed
	target_velocity.y = direction.y * current_speed
	position.y = clamp(position.y, 180, 900)
	velocity = target_velocity
	
	move_and_slide()


func _on_interaction_area_entered(area: Area2D) -> void:
	var entity: Node2D = area.get_parent() # Rename
	
	for group in entity.get_groups():
		if group in can_interact_with:
			if not entity in can_interact_with[group]:
				can_interact_with[group].append(entity)


func _on_interaction_area_exited(area: Area2D) -> void:
	var entity: Node2D = area.get_parent() # Rename
	
	for group in entity.get_groups():
		if group in can_interact_with:
			if entity in can_interact_with[group]:
				can_interact_with[group].erase(entity)


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
