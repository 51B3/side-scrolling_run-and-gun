extends Node
class_name HealthComponent


signal damaged(amount: float)
signal healed(amount: float)
signal died()

var max_health:          float = 100.0
var current_health:      float
var regeneration_timer:  float = 0.0
var regeneration_delay:  float = 2.0
var regeneration_tick:   float = 1.0
var regeneration_amount: float = 1.0
var can_regenerate:      bool  = false


func _ready() -> void:
	current_health = max_health
	regeneration_timer = regeneration_delay


func _process(delta: float) -> void:
	if current_health <= 0:
		return
	
	regeneration_timer -= delta
	
	if not can_regenerate:
		if regeneration_timer <= 0:
			can_regenerate = true
			regeneration_timer = regeneration_tick
	elif current_health < max_health:
		if regeneration_timer <= 0:
			heal(regeneration_amount)
			
			regeneration_timer = regeneration_tick


func damage(amount) -> void:
	if amount <= 0 or current_health <= 0:
		return
	
	current_health = max(current_health - amount, 0)
	
	damaged.emit(amount)
	
	can_regenerate = false
	regeneration_timer = regeneration_delay
	
	if current_health <= 0:
		die()
	
	var parent = get_parent() # Доработать
	
	if parent:
		parent.material.set_shader_parameter("is_white", true)
			
		await get_tree().create_timer(0.1).timeout
			
		parent.material.set_shader_parameter("is_white", false)


func heal(amount) -> void:
	if amount <= 0 or current_health <= 0:
		return
	
	var healed_amount: float = min(amount, max_health - current_health)
	
	if healed_amount <= 0:
		return
	
	current_health += healed_amount
	
	healed.emit(healed_amount)


func die() -> void:
	if current_health > 0:
		return
	
	var parent = get_parent()
	
	if parent:
		died.emit()
		
		parent.queue_free()
