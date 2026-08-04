extends Panel
class_name Slot


@onready var icon: TextureRect = $icon

@export var item_data: ItemData:
	set(value):
		item_data = value
		
		if is_node_ready():
			update_ui()

var ui_manager:     CanvasLayer
var item_drop_area: Control
var is_hovered := false


func _ready() -> void:
	update_ui()
	
	ui_manager = get_tree().current_scene.get_node("CanvasLayer")
	item_drop_area = ui_manager.get_node("item_drop_area")
	
	"""
	gui_input.connect(_on_gui_input)
	"""
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func clear_slot() -> void:
	item_data = null
	
	update_ui()


"""
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			if item_data:
				ui_manager.show_item_details(item_data)
"""


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q and is_hovered:
			quick_drop()
		"""
		elif event.keycode == KEY_E and is_hovered:
			if item_data is FoodData:
				get_tree()\
					.current_scene\
					.get_node("player/hunger_component")\
					.eat(item_data)
				
				clear_slot()
		"""


func quick_drop() -> void:
	if not item_data:
		return
	
	item_drop_area.drop_item(item_data)
	clear_slot()


func update_ui() -> void:
	if not item_data:
		icon.texture = null
		icon.hide()
		tooltip_text = ""
		return
	
	icon.texture = item_data.texture
	icon.show()
	
	"""
	var content: String = ""
	
	if item_data is FoodData:
		content = (
			"\n\nSaturation: " +
			str(item_data.saturation) +
			"\n\nPress {interact} to use\n".format( # item
				{
					"interact": get_action_keys("interact")[0]
				}
			)
		)
	elif item_data is ToolData:
		content = (
			"\n\nPlace in hand to use\n"
		)
	else:
		content = "\n\n"
	
	tooltip_text = (
		item_data.name + 
		content + 
		"Double-click to inspect" # item
	)
	"""


func get_action_keys(action: String) -> PackedStringArray:
	var keys := PackedStringArray()

	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			keys.append(OS.get_keycode_string(event.physical_keycode))
		elif event is InputEventJoypadButton:
			keys.append(str(event.button_index))

	return keys


func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item_data:
		return null
	
	var preview := duplicate()
	var control: Control = Control.new()
	
	control.add_child(preview)
	
	preview.position -= Vector2(25, 25)
	preview.self_modulate = Color.TRANSPARENT
	control.modulate.a = 0.5
	
	set_drag_preview(control)
	icon.hide()
	
	return self


func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	is_hovered = false
