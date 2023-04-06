extends VBoxContainer
var children_count = 0
var pop_count = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	children_count = get_child_count()
	for elem in get_children():
		elem.connect("popped_container", self, "_on_popped_container")
	$HBoxContainer3/Show_ships_button.visible = false
	
func show_button():
	$HBoxContainer3/Show_ships_button.visible = true
	
func _on_popped_container():
	pop_count += 1
	children_count -= 1
	if children_count == 0:
		self.visible = !self.visible
	if pop_count == 2:
		$HBoxContainer3/Switch_turn.set_possible()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
