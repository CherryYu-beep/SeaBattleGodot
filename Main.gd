extends Node2D

signal switch_turn_signal

var rng = RandomNumberGenerator.new()

#var turn = true # true - игрок 2, false - игрок 1
var turn = 2
var count_turns = -1

var rotating = false

var preWin = preload("res://WinMenu.tscn")

func _ready():
	off_visible($Player1_vision)
	off_visible($Player2_vision)
	$Player1_vision/VBoxContainer/VBoxContainer/HBoxContainer3/Switch_turn.connect("switch_turn_signal", self, "_on_Main_switch_turn_signal")
	$Player2_vision/VBoxContainer/VBoxContainer/HBoxContainer3/Switch_turn.connect("switch_turn_signal", self, "_on_Main_switch_turn_signal")
	
	$Player1_vision/VBoxContainer/VBoxContainer/HBoxContainer3/Rotate_button.connect("rotate_ship", self, "_on_rotate_ship")
	$Player2_vision/VBoxContainer/VBoxContainer/HBoxContainer3/Rotate_button.connect("rotate_ship", self, "_on_rotate_ship")
	
	$Player1_vision/VBoxContainer/Ship_menu.connect("game_over", self, "_on_game_over")
	$Player2_vision/VBoxContainer/Ship_menu.connect("game_over", self, "_on_game_over")	
	pass
	
func _on_game_over(turn_):
	for elem in self.get_children():
		elem.visible = !elem.visible
	var obj = preWin.instance()
	self.add_child(obj)
	obj.set_winner(turn_)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func off_visible(elem):
	for el in elem.get_children():
		el.visible = false
	pass

func on_visible(elem):
	for el in elem.get_children():
		el.visible = true
	pass

func _on_rotate_ship():
	rotating = !rotating
	$Player1_vision/Ships_map.set_rotate(rotating)
	$Player1_vision/Shots_map.set_rotate(rotating)
	$Player2_vision/Ships_map.set_rotate(rotating)
	$Player2_vision/Shots_map.set_rotate(rotating)

func _on_Main_switch_turn_signal():
#	var caption = "Player %s \n Close your eyes" % turn
#	$VBoxContainer_switching_turn/Label_switching_turn.text = caption
#	$VBoxContainer_switching_turn.visible = !$VBoxContainer_switching_turn.visible
#	off_visible($Player1_vision)
#	off_visible($Player2_vision)
	switching_turn()

func switching_turn():
	if turn == 1:
		turn = 2
		$Player1_vision/Ships_map.set_turn(2)
		$Player1_vision/Shots_map.set_turn(2)
		$Player2_vision/Ships_map.set_turn(2)
		$Player2_vision/Shots_map.set_turn(2)
	else:
		turn = 1
		$Player1_vision/Ships_map.set_turn(1)
		$Player1_vision/Shots_map.set_turn(1)
		$Player2_vision/Ships_map.set_turn(1)
		$Player2_vision/Shots_map.set_turn(1)
	
	var caption = 'Player\'s ' + str(turn) + ' turn'
	if turn == 2:
		off_visible($Player1_vision)
		on_visible($Player2_vision)
	else:
		on_visible($Player1_vision)
		off_visible($Player2_vision)
	rotating = false
	$Player1_vision/Ships_map.set_rotate(rotating)
	$Player1_vision/Shots_map.set_rotate(rotating)
	$Player2_vision/Ships_map.set_rotate(rotating)
	$Player2_vision/Shots_map.set_rotate(rotating)
	$label_turn.text = caption
	count_turns += 1
	if count_turns > 1:
		$Player1_vision.set_hide_ships()
		$Player2_vision.set_hide_ships()
		set_possible_visions()
		get_tree().call_group("show_ships", "show_button")
		$Player1_vision/VBoxContainer.show_ship_menu(turn)
		$Player2_vision/VBoxContainer.show_ship_menu(turn)
		$Player1_vision/VBoxContainer/VBoxContainer/HBoxContainer3/Rotate_button.visible = false
		$Player2_vision/VBoxContainer/VBoxContainer/HBoxContainer3/Rotate_button.visible = false


func set_possible_visions():
	$Player1_vision.set_possible()
	$Player2_vision.set_possible()

func _on_StartGame_pressed():
	on_visible($Player1_vision)
	emit_signal("switch_turn_signal")
	$StartGame.queue_free()
	pass # Replace with function body.


func _on_Shots_map_shot(shot_position):
	if turn == 1:
		$Player1_vision.set_possible_from_vision()
	else:
		$Player2_vision.set_possible_from_vision()
	shotting(turn, shot_position)

func shotting(info, shot_position):
	var current_player
	var versus_player
	if info == 1:
		current_player = 1
		versus_player = 2
	else:
		current_player = 2
		versus_player = 1
		
	var current_ships = get_node("Player%s_vision/Ships_map" % current_player)
	var current_shots = get_node("Player%s_vision/Shots_map" % current_player)
	
	var versus_ships = get_node("Player%s_vision/Ships_map" % versus_player)
	
	for ship in versus_ships.get_children():
#		print(ship)
		var pos_array = ship.get_node("TileMap").get_used_cells()
		var count = -1
		for elem in pos_array:
			count += 1
			if (shot_position[0] - ship.position[0] - elem[0] * 60 == 0 and
			shot_position[1] - ship.position[1] - elem[1] * 60 == 0):
				ship.do_damage(count)
				current_shots.set_cell(shot_position[0] / 60, shot_position[1] / 60, 4)
				set_possible_visions()
				$Player1_vision.unset_possible_from_vision()
				$Player2_vision.unset_possible_from_vision()
				if ship.check_damage():
					for i in range(ship.lenght):
						if ship.is_rotated:
							current_shots.set_cell(ship.position[0] / 60, ship.position[1] / 60 + i, 2)
#							set_possible_visions()
						else:
							current_shots.set_cell(ship.position[0] / 60 + i, ship.position[1] / 60, 2)
#							set_possible_visions()
						current_shots.update_bitmask_region()


func _on_Player1_vision_ship_on_map_destroyed(pos, rotating, lenght):
	$Player2_vision/Shots_map.boom_draw(pos, rotating, lenght)
	$Player2_vision/VBoxContainer/Ship_menu.count_lefted_ships(2)
	print(2)
	pass # Replace with function body.


func _on_Player2_vision_ship_on_map_destroyed(pos, rotating, lenght):
	$Player1_vision/Shots_map.boom_draw(pos, rotating, lenght)
	$Player1_vision/VBoxContainer/Ship_menu.count_lefted_ships(1)
	print(1)
	
	pass # Replace with function body.
