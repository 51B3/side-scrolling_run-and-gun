extends ItemData
class_name RangedWeaponData


"""
enum FireMode {
	SINGLE,
	BURST,
	AUTO
}

@export var fire_mode:             FireMode = FireMode.SINGLE
@export var bullet_override:       BulletData
"""
@export var ammo_data:             AmmoData
@export var magazine_size:         int = 30
@export var reload_time:           float = 1.0
@export var velocity_multiplier:   float = 1.0
@export var damage_multiplier:     float = 1.0
@export var muzzle_position:       Vector2 = Vector2(0.0, 0.0)
# Скорострельность
"""
@export var projectile_count:      int = 1 # 
@export var burst_count:           int = 1 # 
@export var min_spread:            float = 0.0
@export var max_spread:            float = 5.0
@export var spread_recovery:       float = 8.0
@export var recoil_force:          float = 0.0 # 
@export var screen_shake:          float = 0.2 # 
"""
@export var shoot_sound:           AudioStream
@export var empty_chambered_sound: AudioStream
@export var shoot_particles:       PackedScene
@export var reload_sound:          AudioStream
