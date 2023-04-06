extends HBoxContainer

signal game_over
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = !self.visible
	pass # Replace with function body.

func count_lefted_ships(turn):
	var current_array = [-1, 0, 0, 0, 0]
	var versus_array = [-1, 0, 0, 0, 0]
	var current_player
	var versus_player
	
	if turn == 1:
		current_player = 1
		versus_player = 2
	else:
		current_player = 2
		versus_player = 1
		
	for elem in get_tree().get_nodes_in_group('player' + str(current_player)):
		for i in range(1, 5):
			if elem.is_in_group('ship' + str(i)):
				current_array[i] += 1
	
	for elem in get_tree().get_nodes_in_group('player' + str(versus_player)):
		for i in range(1, 5):
			if elem.is_in_group('ship' + str(i)):
				versus_array[i] += 1
	
	var versus_check_count = 0
	for i in range(1, 5):
		get_node("VBoxContainer%s/HBoxContainer%s/Label" % [1, i]).text = "Left: %s" % versus_array[i]
		get_node("VBoxContainer%s/HBoxContainer%s/Label" % [2, i]).text = "Left: %s" % current_array[i]
		if versus_array[i] == 0:
			versus_check_count += 1
	
	if versus_check_count == 4:
		emit_signal("game_over", turn)
#	print()
#	print(current_array)
#	print()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
