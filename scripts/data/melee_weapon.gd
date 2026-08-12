extends ItemData
class_name MeleeWeaponData


"""
enum DamageType {
	
}

@export var damage_type:     DamageType
"""
@export var damage:          float = 10.0
@export var attack_cooldown: float = 1.0
# combo_<...>
"""
@export var swing_particles: PackedScene # swing_trail
@export var swing_sound:     AudioStream
@export var hit_particles:   PackedScene
@export var hit_sound:       AudioStream
"""
