extends Node2D
class_name RangedWeapon


signal ammo_changed(current: int, max: int) # , reserve: int

@export var data: RangedWeaponData

var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
var is_reloading: bool = false
var ammo:         int = 0: # Переименовать
	set(value):
		ammo = clampi(value, 0, data.magazine_size)
		
		ammo_changed.emit(ammo, data.magazine_size)
"""
var reserve_ammo: int = 0:
	set(value):
		reserve_ammo = maxi(value, 0)
"""


func _ready() -> void:
	$muzzle.position = data.muzzle_position
	ammo = data.magazine_size
	"""
	reserve_ammo = ammo
	"""


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	if Input.is_action_just_pressed("shoot"):
		shoot() # SINGLE/BURST/AUTO
	
	if Input.is_action_just_pressed("reload"):
		reload()


func shoot() -> void:
	if is_reloading:
		return
	
	if ammo <= 0:
		if data.empty_chambered_sound:
			var audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			
			get_tree().current_scene.add_child(audio_stream_player)
			
			audio_stream_player.stream = data.empty_chambered_sound
			audio_stream_player.global_position = global_position
			
			audio_stream_player.finished.connect(audio_stream_player.queue_free)
			audio_stream_player.play()
		
		"""
		if reserve_ammo > 0:
			reload()
		"""
		
		return
	
	ammo -= 1
	
	var bullet_instance = bullet_scene.instantiate()
	
	"""
	"""
	bullet_instance.data = data.ammo_data.bullet_data
	"""
	"""
	
	get_tree().current_scene.add_child(bullet_instance)
	
	bullet_instance.global_position = $muzzle.global_position
	bullet_instance.rotation = rotation


func reload() -> void:
	if is_reloading or ammo >= data.magazine_size:
		return
	
	"""
	if reserve_ammo <= 0:
		return
	"""
	
	is_reloading = true
	
	await get_tree().create_timer(data.reload_time).timeout
	
	"""
	var needed_ammo: int = data.magazine_size - ammo
	var ammo_to_reload: int = mini(needed_ammo, reserve_ammo)
	
	ammo += ammo_to_reload
	reserve_ammo -= ammo_to_reload
	"""
	
	ammo = data.magazine_size
	is_reloading = false
