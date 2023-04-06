extends TileMap

signal child_added 
signal shot

var preship = preload("res://ship_scene.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var map_click_radius = 9
var turn
var ship_len = -1
var rotating = false
var is_ghost_ship_exist = false

func set_ghost_ship_exist(info: bool):
	is_ghost_ship_exist = info

func get_len():
	return ship_len
	
func set_len(info: int):
	ship_len = info
	
func get_rotating():
	return rotating

func set_rotate(info: bool):
	rotating = info

func set_turn(info: int):
	turn = info

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_map(field_create())
	pass # Replace with function body.
	
func field_create():
	var obj = []
	for i in range(0, 10):
		obj.append([])
		for j in range(0, 10):
			obj[i].append(0)
	return obj

func draw_map(arr: Array):
	for i in range(10):
		for j in range(10):
			$".".set_cell(i, j, arr[i][j])
	pass
	
func spawn_ship(is_rotated_: bool, lenght_: int, pos_: Vector2):
	var obj = preship.instance()
	obj.is_rotated = is_rotated_
	obj.lenght = lenght_
	obj.pos = pos_
	obj.add_to_group("ship" + str(lenght_))
	obj.add_to_group('player' + str(turn))
	self.add_child(obj)
	emit_signal("child_added")
	obj.emit_placed()
	
func boom_draw(pos, rotating, lenght):
	if rotating:
		for i in range(3):
			for j in range(pos[1] / 60 - 1, pos[1] / 60 + lenght + 1):
				if j >= 0 and pos[0] / 60 - 1 + i >= 0 and pos[0] / 60 - 1 + i <= 9:
					self.set_cell(pos[0] / 60 - 1 + i, j, 5)
	else:
		for i in range(pos[0] / 60 - 1, pos[0] / 60 + lenght + 1):
			for j in range(3):
				if pos[1] / 60 - 1 + j >= 0 and i >= 0 and i <= 9 and j <= 9:
					self.set_cell(i, pos[1] / 60 - 1 + j, 5)
	pass

func is_around_clear(rotating_, ship_len_, mouse_position_):
	if rotating_:
		for i in range(mouse_position_[0] - 1, mouse_position_[0]  + 2):
			for j in range(mouse_position_[1] - 1, mouse_position_[1] + ship_len_ + 1):
				for elem in self.get_children():
					if elem.is_rotated:
						for k in range(elem.pos[1], elem.pos[1] + elem.lenght):
							if i == elem.pos[0] and j == k:
								return false
					else:
						for k in range(elem.pos[0], elem.pos[0] + elem.lenght):
							if i == k and j == elem.pos[1]:
								return false
	else:
		for i in range(mouse_position_[0] - 1, mouse_position_[0] + ship_len_ + 1):
			for j in range(mouse_position_[1] - 1, mouse_position_[1] + 2):
				for elem in self.get_children():
					if elem.is_rotated:
						for k in range(elem.pos[1], elem.pos[1] + elem.lenght):
							if i == elem.pos[0] and j == k:
								return false
					else:
						for k in range(elem.pos[0], elem.pos[0] + elem.lenght):
							if i == k and j == elem.pos[1]:
								return false
	return true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var mouse_position = get_local_mouse_position()
			mouse_position[0] = floor(get_local_mouse_position()[0] / 60)
			mouse_position[1] = floor(get_local_mouse_position()[1] / 60)
			if (mouse_position[0] <= 9 and mouse_position[0] >= 0 and
			self.visible == true):
				var global_tile_position = Vector2(map_to_world(mouse_position)[0] + self.position[0],
				map_to_world(mouse_position)[1] + self.position[1])
				if self.is_in_group("ships") and is_ghost_ship_exist:
					if rotating:
						if mouse_position[1] + ship_len <= map_click_radius + 1:
							if is_around_clear(rotating, ship_len, mouse_position):
								spawn_ship(rotating, ship_len, mouse_position)
					else:
						if mouse_position[0] + ship_len <= map_click_radius + 1:
							if is_around_clear(rotating, ship_len, mouse_position):
								spawn_ship(rotating, ship_len, mouse_position)
				if self.is_in_group("shots") and get_parent().possible:
					if (self.get_cell(mouse_position[0], mouse_position[1]) != 5 and
					self.get_cell(mouse_position[0], mouse_position[1]) != 2 and
					self.get_cell(mouse_position[0], mouse_position[1]) != 4):
						self.set_cell(mouse_position[0], mouse_position[1], 5)
						get_parent().possible = false
						emit_signal("shot", global_tile_position)
