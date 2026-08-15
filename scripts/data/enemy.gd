extends Resource
class_name EnemyData


"""
enum AttackType {
	
}
"""

@export var texture:         Texture
"""
@export var sprite_frames:    SpriteFrames
"""
@export var speed:           float = 128.0
@export var attack_damage:   float = 10.0 # Переименовать
@export var attack_cooldown: float = 1.0

@export_category("health_component.gd")
@export var max_health:          float = 100.0
@export var regeneration_delay:  float = 2.0
@export var regeneration_tick:   float = 1.0
@export var regeneration_amount: float = 1.0
