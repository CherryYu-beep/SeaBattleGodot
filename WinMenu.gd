extends Node2D

var winner_is
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Winner1.visible = !$Winner1.visible
	$Winner2.visible = !$Winner2.visible
	pass # Replace with function body.

func set_winner(info):
	get_node("Winner%s" % info).visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
