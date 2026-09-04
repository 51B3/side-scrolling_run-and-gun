extends Node
class_name AmmoComponent


signal ammo_changed(ammo_data: AmmoData, amount: int)

var ammo: Dictionary[AmmoData, int] = {}


func get_amount(ammo_data: AmmoData) -> int:
	if ammo_data == null:
		return 0
	
	return ammo.get(ammo_data, 0)


func add(ammo_data: AmmoData, amount: int) -> void:
	if ammo_data == null or amount <= 0:
		return
	
	ammo[ammo_data] = get_amount(ammo_data) + amount
	
	ammo_changed.emit(ammo_data, ammo[ammo_data])


func remove(ammo_data: AmmoData, amount: int) -> bool:
	if ammo_data == null or amount <= 0:
		return false
	
	var current_amount: int = get_amount(ammo_data)
	
	if current_amount < amount:
		return false
	
	current_amount -= amount
	
	if current_amount == 0:
		ammo.erase(ammo_data)
	else:
		ammo[ammo_data] = current_amount
	
	ammo_changed.emit(ammo_data, current_amount)
	
	return true


func has(ammo_data: AmmoData, amount: int = 1) -> bool:
	return get_amount(ammo_data) >= amount


func clear(ammo_data: AmmoData) -> void:
	if ammo_data == null:
		return
	
	if not ammo.has(ammo_data):
		return
	
	ammo.erase(ammo_data)
	
	ammo_changed.emit(ammo_data, 0)


func get_all() -> Dictionary[AmmoData, int]:
	return ammo.duplicate()
