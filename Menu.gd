extends VBoxContainer

signal show_ships
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func show_ship_menu(turn):
	$Ship_menu.visible = true
	$Ship_menu.count_lefted_ships(turn)

func set_possible_from_container():
	$VBoxContainer/HBoxContainer3/Switch_turn.set_possible()
	
func unset_possible_from_container():
	$VBoxContainer/HBoxContainer3/Switch_turn.unset_possible()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#	$VBoxContainer/Label_under_switch.text = caption


func _on_Show_ships_button_pressed():
	emit_signal("show_ships")
	pass # Replace with function body.
