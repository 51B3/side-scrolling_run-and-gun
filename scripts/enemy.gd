extends CharacterBody2D
class_name Zombie


@onready var player:           CharacterBody2D = (
	get_tree()
	.current_scene
	.get_node("player")
)
@onready var health_bar:       ProgressBar = $health/ProgressBar
@onready var health_component: Node = $health_component

@export var data: EnemyData:
	set(value):
		if data == value:
			return
		
		data = value
		
		"""
		if is_node_ready():
			_draw()
		"""
@export var speed:           float = 128.0
@export var attack_damage:   float = 10.0
@export var attack_cooldown: float = 1.0

var attack_timer: float = 0.0
var is_attacking: bool = false


func _ready() -> void:
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health
	
	health_component.damaged.connect(_on_health_changed)
	health_component.healed.connect(_on_health_changed)


func _physics_process(delta: float) -> void:
	if not player:
		return
	
	var direction: Vector2 = (player.global_position - global_position).normalized()
	
	velocity = direction * speed
	position.y = clamp(position.y, 250, 450)
	
	move_and_slide()
	
	if is_attacking:
		attack_timer -= delta
		
		if attack_timer <= 0.0:
			player.get_node("health_component").damage(attack_damage)
			
			attack_timer = attack_cooldown


func _on_health_changed(_amount: float) -> void:
	health_bar.value = health_component.current_health


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_node("health_component").damage(attack_damage)
		
		is_attacking = true
		attack_timer = attack_cooldown


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_attacking = false
		attack_timer = 0.0
