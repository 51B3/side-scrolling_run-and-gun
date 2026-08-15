extends Node2D
class_name MeleeWeapon


@export var data: MeleeWeaponData:
	set(value):
		if data == value:
			return
		
		data = value
		
		"""
		if is_node_ready():
			_draw()
		"""


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func attack() -> void:
	pass
