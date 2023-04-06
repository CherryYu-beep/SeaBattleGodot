extends TextureButton

signal rotate_ship

func _ready():
	pass # Replace with function body.

func _on_Rotate_button_pressed():
	emit_signal("rotate_ship")
#	print(len(get_tree().get_nodes_in_group("ship1")))
	pass # Replace with function body.
