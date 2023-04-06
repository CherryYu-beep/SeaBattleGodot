extends Node2D

var possible = false
var preghostship = preload("res://ghostship_scene.tscn")
var obj
var rotating

signal ship_on_map_destroyed

func set_possible():
	possible = true
	
func set_hide_ships():
	$Ships_map.visible = false

func _ready():
	$VBoxContainer/VBoxContainer/HBoxContainer/Button1.connect("ghost_ship", self, "_on_ghost_ship")
	$VBoxContainer/VBoxContainer/HBoxContainer/Button2.connect("ghost_ship", self, "_on_ghost_ship")
	$VBoxContainer/VBoxContainer/HBoxContainer/Button3.connect("ghost_ship", self, "_on_ghost_ship")
	$VBoxContainer/VBoxContainer/HBoxContainer2/Button4.connect("ghost_ship", self, "_on_ghost_ship")
	$Ships_map.connect("child_added", self, "_on_child_added")
	$VBoxContainer/VBoxContainer/HBoxContainer3/Rotate_button.connect("rotate_ship", self, "_on_rotate_ship")
	$VBoxContainer.connect("show_ships", self, "_on_show_ships")

func _on_show_ships():
	$Ships_map.visible = !$Ships_map.visible
	pass
	
func _on_rotate_ship():
	rotating = !rotating
	for elem in self.get_children():
		if elem.is_in_group("ghost"):
			var lenght = elem.lenght
			elem.queue_free()
			create_ghost_ship(lenght)
	pass
	
func _on_ghost_ship(ship_type):
	create_ghost_ship(ship_type)
	pass
	
func create_ghost_ship(type):
	get_tree().call_group("ghost", "queue_free")
	obj = preghostship.instance()
	rotating = $Ships_map.get_rotating()
	obj.is_rotated = rotating
	obj.lenght = type
	$Ships_map.set_len(type)
	obj.add_to_group("ghost")
	self.add_child(obj)
	$Ships_map.set_ghost_ship_exist(true)


func _on_child_added():
	for elem in $Ships_map.get_children():
		if elem.is_connected("placed", self, "_on_placed"):
			pass
		else:
			elem.connect("placed", self, "_on_placed")
		if elem.is_connected("destroyed", self, '_on_ship_destroyed'):
			pass
		else:
			elem.connect("destroyed", self, '_on_ship_destroyed')

func _on_ship_destroyed(pos, rotating, lenght):
	emit_signal("ship_on_map_destroyed", pos, rotating, lenght)
	pass

func _on_placed(info):
	get_tree().call_group("ghost", "queue_free")
	$Ships_map.set_ghost_ship_exist(false)
	for elem in $VBoxContainer/VBoxContainer/HBoxContainer.get_children():
		if elem.is_in_group(str(info)):
			elem.decrement_ships()
	for elem in $VBoxContainer/VBoxContainer/HBoxContainer2.get_children():
		if elem.is_in_group(str(info)):
			elem.decrement_ships()

func set_possible_from_vision():
	$VBoxContainer.set_possible_from_container()
	
func unset_possible_from_vision():
	$VBoxContainer.unset_possible_from_container()
