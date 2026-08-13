extends CanvasLayer


@onready var pause_menu:       Control = $pause_menu
@onready var player:           CharacterBody2D = (
	get_tree()
	.current_scene
	.get_node("player")
)
@onready var ammo_bar:         ProgressBar = $header/VBoxContainer/ammo/HBoxContainer/ProgressBar
@onready var ammo_label:       Label = $header/VBoxContainer/ammo/HBoxContainer/Label
@onready var health_bar:       ProgressBar = $header/VBoxContainer/health/ProgressBar
@onready var health_component: Node = ( # player
	get_tree()
	.current_scene
	.get_node("player/health_component")
)


func _ready() -> void: # setter
	await get_tree().process_frame
	
	var ranged_weapon = player.get_node("ranged_weapon")
	
	"""
	if not weapon:
		ammo_bar.hide()
		ammo_label.hide()
	"""
	
	ammo_bar.max_value = ranged_weapon.data.magazine_size # 
	ammo_bar.value = ranged_weapon.ammo # 
	
	ranged_weapon.ammo_changed.connect(_on_ammo_changed) # 
	
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health
	
	health_component.damaged.connect(_on_health_changed)
	health_component.healed.connect(_on_health_changed)


func _on_health_changed(_amount: float) -> void: # player
	health_bar.value = health_component.current_health


func _on_weapon_changed() -> void: # 
	pass 


func _on_ammo_changed(current: int, _max: int) -> void: # player
	ammo_bar.max_value = _max
	ammo_bar.value = current
	ammo_label.text = "%d/%d" % [current, _max]


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		handle_ui_cancel()


func handle_ui_cancel() -> void:
	if pause_menu.get_node("settings").visible:
		pause_menu.get_node("settings").hide()
		pause_menu.get_node("PanelContainer").show()
		
		return
	
	if pause_menu.visible:
		pause_menu.hide()
		
		get_tree().paused = false
		
		# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		return
	
	pause_menu.show()
	
	get_tree().paused = true
	
	# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
