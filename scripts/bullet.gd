extends Node2D


@export var data: BulletData:
	set(value):
		if data == value:
			return
		
		data = value
		
		"""
		if is_node_ready():
			_draw()
		"""


func _ready() -> void:
	if data == null:
		queue_free()
		
		return
	
	"""
	_draw()
	"""


func _physics_process(delta: float) -> void:
	position += transform.x * data.velocity * delta


func _on_screen_exited() -> void:
	queue_free()


func _on_attack_area_body_entered(body: Node2D) -> void:	
	if not body.is_in_group("enemy"):
		return
	
	body.get_node("health_component").damage(data.damage)
	
	if data.hit_particles:
		var particles_instance = data.hit_particles.instantiate()
		
		get_tree().current_scene.add_child(particles_instance)
		
		@warning_ignore_start("incompatible_ternary")
		
		particles_instance.global_position = global_position
		particles_instance.rotation = 0 if scale.x > 0 else PI
		particles_instance.get_node("CPUParticles2D").emitting = true
		
		@warning_ignore_restore("incompatible_ternary")
	
	if data.hit_sound:
		var audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		
		get_tree().current_scene.add_child(audio_stream_player)
		
		audio_stream_player.stream = data.hit_sound
		audio_stream_player.global_position = global_position
		
		audio_stream_player.finished.connect(audio_stream_player.queue_free)
		audio_stream_player.play()
	
	queue_free()
