extends Resource
class_name BulletData


"""
enum DamageType {
	
}

@export var damage_type:      DamageType
# @export var texture:          Texture
"""
@export var damage:           float = 10.0
@export var velocity:         float = 10000.0
"""
@export var explosion_radius: float = 0.0 # 
@export var explosion_damage: float = 0.0 # 
@export var trail:            PackedScene
"""
@export_group("Design(?)") # Rename
@export var hit_particles:    PackedScene #
@export var hit_sound:        AudioStream # 
