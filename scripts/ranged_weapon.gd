extends Node2D
class_name RangedWeapon


signal ammo_changed(current: int, max: int)

@export var magazine_size:   int
@export var muzzle_position: Vector2
@export var bullet_velocity: float = 10000.0
@export var reload_time:     float
# @export var ammo_type:       String
# @export var damage:          float

var bullet_scene := preload("res://scenes/bullet.tscn") # resource
var is_reloading: bool = false
var ammo: int = 0:
	set(value):
		ammo = value
		ammo_changed.emit(ammo, magazine_size)


func _ready() -> void:
	$muzzle.position = muzzle_position
	ammo = magazine_size


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if Input.is_action_just_pressed("reload"):
		reload()


func shoot() -> void:
	if is_reloading:
		return
	
	if ammo <= 0:
		return # Click sound
	
	ammo -= 1
	
	var bullet_instance = bullet_scene.instantiate()
	
	get_tree().current_scene.add_child(bullet_instance)
	
	bullet_instance.velocity = bullet_velocity # resource
	bullet_instance.global_position = $muzzle.global_position
	bullet_instance.rotation = rotation


func reload() -> void:
	if is_reloading:
		return
	
	if ammo == magazine_size:
		return
	
	"""
	var reserve = player.reserve_ammo[ammo_type]
	
	if reserve <= 0:
		return
	"""
	
	is_reloading = true
	
	"""
	var need = magazine_size - ammo
	var take = min(need, reserve)
	
	ammo += take
	player.reserve_ammo[ammo_type] -= take
	"""
	
	await get_tree().create_timer(reload_time).timeout # reload_time
	
	is_reloading = false
