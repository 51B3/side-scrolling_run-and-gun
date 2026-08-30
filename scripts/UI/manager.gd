extends CanvasLayer


@onready var pause_menu:       Control = $pause_menu
@onready var player:           CharacterBody2D = (
	get_tree()
	.current_scene
	.get_node("player")
)
# Перенести в player.gd
@onready var ammo_bar:         ProgressBar = $HUD/VBoxContainer/ammo/HBoxContainer/ProgressBar
@onready var ammo_label:       Label = $HUD/VBoxContainer/ammo/HBoxContainer/Label
@onready var health_bar:       ProgressBar = $HUD/VBoxContainer/health/ProgressBar
@onready var health_component: Node = player.get_node("health_component")


func _ready() -> void:
	await get_tree().process_frame
	
	var ranged_weapon = player.get_node("weapons/ranged")
	
	if not ranged_weapon.visible:
		ammo_bar.hide()
		ammo_label.hide()
	
	ammo_bar.max_value = ranged_weapon.data.magazine_size
	ammo_bar.value = ranged_weapon.magazine_ammo
	
	ranged_weapon.magazine_ammo_changed.connect(_on_magazine_ammo_changed)
	
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health
	
	health_component.damaged.connect(_on_health_changed)
	health_component.healed.connect(_on_health_changed)


func _on_health_changed(_amount: float) -> void:
	health_bar.value = health_component.current_health


func _on_weapon_changed() -> void: # 
	pass 


func _on_magazine_ammo_changed(magazine_ammo: int, magazine_size: int) -> void:
	ammo_bar.max_value = magazine_size
	ammo_bar.value = magazine_ammo
	ammo_label.text = "%d/%d" % [magazine_ammo, magazine_size]


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		handle_ui_cancel()
	
	if Input.is_action_just_pressed("two-handed_ranged_weapon"):
		pass # player.ranged_weapon.data = two-handed_ranged_weapon
			 # player.melee_weapon.hide()
	
	if Input.is_action_just_pressed("one-handed_ranged_weapon"):
		pass # player.ranged_weapon.data = one-handed_ranged_weapon
			 # player.melee_weapon.hide()
		
	if Input.is_action_just_pressed("melee_weapon"):
		pass # player.melee_weapon.show()
			 # player.ranged_weapon.hide()


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
