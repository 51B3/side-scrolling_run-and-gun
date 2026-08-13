extends Node2D


@export var bullet_data: BulletData:
	set(value):
		if bullet_data == value:
			return
		
		bullet_data = value
		
		"""
		if is_node_ready():
			_draw()
		"""


func _ready() -> void:
	if bullet_data == null:
		queue_free()
		
		return
	
	"""
	_draw()
	"""


func _physics_process(delta: float) -> void:
	position += transform.x * bullet_data.velocity * delta


func _on_screen_exited() -> void:
	queue_free()


func _on_attack_area_body_entered(body: Node2D) -> void:	
	if not body.is_in_group("zombie"):
		return
	
	body.get_node("health_component").damage(bullet_data.damage)
	
	if bullet_data.hit_particles:
		var particles = bullet_data.hit_particles.instantiate()
		
		get_tree().current_scene.add_child(particles)
		
		particles.global_position = global_position
		particles.rotation = rotation
	
	if bullet_data.hit_sound:
		var audio_stream_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		
		get_tree().current_scene.add_child(audio_stream_player)
		
		audio_stream_player.stream = bullet_data.hit_sound
		audio_stream_player.global_position = global_position
		
		audio_stream_player.finished.connect(audio_stream_player.queue_free)
		audio_stream_player.play()
	
	queue_free()
