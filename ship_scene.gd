extends Node2D

signal placed
signal destroyed

var is_rotated
var lenght 
var pos
var damage_array = []

func _ready():
	for i in range(lenght):
		damage_array.append(false)
	self.position[0] = pos[0] * 60
	self.position[1] = pos[1] * 60
	if is_rotated:
		for i in range(lenght):
			$TileMap.set_cell(0, i, 1)
			$TileMap.update_bitmask_region()
	else:
		for i in range(lenght):
			$TileMap.set_cell(i, 0, 1)
			$TileMap.update_bitmask_region()
			
	pass

func check_damage():
	var lenght_array = len(damage_array)
	var count = 0
	for i in range(lenght_array):
		if damage_array[i] == true:
			count += 1
	return count == lenght_array

#func set_destroyed():
#	var used_cells = $TileMap.get_used_cells()
#	for i in used_cells:
#		$TileMap.set_cell(i[0], i[1], 2)
#		print($TileMap.get_used_cells_by_id(2))
#	$TileMap.update_bitmask_region()

func do_damage(info):
	damage_array[info] = true
	if is_rotated:
		$TileMap.set_cell(0, info, 2)
		$TileMap.update_bitmask_region()
	else:
		$TileMap.set_cell(info, 0, 2)
		$TileMap.update_bitmask_region()
	if check_damage():
		for group in self.get_groups():
#			print(group)
			self.remove_from_group(group)
		emit_signal("destroyed", self.position, self.is_rotated, self.lenght)

func emit_placed():
	emit_signal("placed", lenght)
#func _process(delta):
#	pass
