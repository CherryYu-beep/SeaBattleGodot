extends Node2D

var is_rotated
var lenght 

func _ready():
	if is_rotated:
		for i in range(lenght):
			$TileMap.set_cell(0, i, 3)
			$TileMap.update_bitmask_region()
	else:
		for i in range(lenght):
			$TileMap.set_cell(i, 0, 3)
			$TileMap.update_bitmask_region()

func _process(delta):
	self.position[0] = get_global_mouse_position()[0] - 30
	self.position[1] = get_global_mouse_position()[1] - 30	
	
