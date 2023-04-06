extends Button

var ships

signal popped
signal ghost_ship

func _ready():
	if self.is_in_group("1"):
		ships = 4
	elif self.is_in_group("2"):
		ships = 3
	elif self.is_in_group("3"):
		ships = 2
	else:
		ships = 1
	pass # Replace with function body.

func decrement_ships():
	ships -= 1
	if ships == 0:
		emit_signal("popped")
		self.queue_free()

func _on_Button_pressed():
	emit_signal("ghost_ship", int(get_groups()[-1]))
#	decrement_ships()
