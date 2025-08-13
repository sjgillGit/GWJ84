extends Control
var sequence: Array = ["Z","left","right","down","up","left","right","down","up","P"]
var nail_spread: float
var starting_x: =- 0.8
#@onready var middle: Node3D = $SubViewportContainer/SubViewport/Camera3D/middle
#@onready var board: Node3D = $SubViewportContainer/SubViewport/Camera3D/board
const NAIL = preload("res://Scenes/UI/lockpick/nail.tscn")
@onready var nail_parent: Node3D = $SubViewportContainer/SubViewport/Camera3D/nail_parent
func _ready() -> void:
	nail_spread = 220 / sequence.size()
	print(3 / sequence.size())
	for n in sequence.size():
		var nail_position = get_nail_position(n)
		var nail_inst = NAIL.instantiate()
		nail_parent.add_child(nail_inst)
		nail_inst.position = nail_position
		nail_inst.set_nail(sequence[n],0)
		
func get_nail_position(number):
	var x: float = starting_x + (nail_spread/100) * number
	print(x)
	return Vector3(x,0,-2.042)
