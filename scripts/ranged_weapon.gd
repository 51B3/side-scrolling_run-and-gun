extends Node2D
class_name RangedWeapon


signal magazine_ammo_changed(magazine_ammo: int, magazine_size: int)

@export var data: RangedWeaponData

var bullet_scene:  PackedScene = preload("res://scenes/bullet.tscn")
var is_reloading:  bool = false
var magazine_ammo: int = 0


func _ready() -> void:
	$muzzle.position = data.muzzle_position
	magazine_ammo = data.magazine_size
	
	await get_tree().process_frame
	
	magazine_ammo_changed.emit(magazine_ammo, data.magazine_size)


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
	
	if magazine_ammo <= 0:
		if data.empty_chambered_sound:
			var audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			
			get_tree().current_scene.add_child(audio_stream_player)
			
			audio_stream_player.stream = data.empty_chambered_sound
			audio_stream_player.global_position = global_position
			
			audio_stream_player.finished.connect(audio_stream_player.queue_free)
			audio_stream_player.play()
		
		if Global.get_amount(data.ammo_data) > 0:
			reload()
		
		return
	
	magazine_ammo -= 1
	
	magazine_ammo_changed.emit(magazine_ammo, data.magazine_size)
	
	var bullet_instance = bullet_scene.instantiate()
	
	bullet_instance.data = (
		data.
		ammo_data.
		bullet_data
	)
	
	get_tree().current_scene.add_child(bullet_instance)
	
	bullet_instance.global_position = $muzzle.global_position
	bullet_instance.rotation = rotation


func reload() -> void:
	if is_reloading or magazine_ammo >= data.magazine_size:
		return
	
	if Global.get_amount(data.ammo_data) <= 0:
		return
	
	is_reloading = true
	
	await get_tree().create_timer(data.reload_time).timeout
	
	var reload_ammo: int = mini(
		data.magazine_size - magazine_ammo,
		Global.get_amount(data.ammo_data)
	)
	
	magazine_ammo += reload_ammo
	
	Global.remove(data.ammo_data, reload_ammo)
	
	is_reloading = false
	
	magazine_ammo_changed.emit(magazine_ammo, data.magazine_size)
