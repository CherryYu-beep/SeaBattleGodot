extends HBoxContainer
var children_count = 0

signal popped_container
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	children_count = get_child_count()
	for elem in get_children():
		elem.connect("popped", self, "_on_popped")
		
	
func _on_popped():
	children_count -= 1
	if children_count == 0:
		self.visible = !self.visible
		emit_signal("popped_container")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
