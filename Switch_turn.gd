extends TextureButton

var possible = false

signal switch_turn_signal

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_possible():
	possible = true
	self.self_modulate = Color(0, 1, 0, 1)
	
func unset_possible():
	possible = false
	self.visible = !self.visible
	self.self_modulate = Color(1, 0, 0, 1)
	self.visible = !self.visible

func _on_Switch_turn_pressed():
	if possible:
		emit_signal("switch_turn_signal")
		unset_possible()
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == 16777221:
			if possible:
				emit_signal("switch_turn_signal")
				unset_possible()
