extends Control
var sequence: Array = ["Z","left","right","down","up","left","right","down","up","P"]
var nail_spread: float
var starting_x: =- 0.6
var step: int = 0
const NAIL = preload("res://Scenes/UI/lockpick/nail.tscn")
@onready var nail_parent: Node3D = $SubViewportContainer/SubViewport/Camera3D/nail_parent
func _ready() -> void:
	nail_spread = 200 / sequence.size()
	for n in sequence.size():
		var nail_position = get_nail_position(n)
		var nail_inst = NAIL.instantiate()
		nail_parent.add_child(nail_inst)
		nail_inst.position = nail_position
		nail_inst.set_nail(sequence[n],0)
		
func get_nail_position(number):
	var is_even = is_even(number)
	var y
	if is_even: y = 0.05
	else: y = -0.05

	var x: float = starting_x + (nail_spread/100) * number
	return Vector3(x,y,-2.042)
	
func is_even(x: int):
	return x % 2 == 0

func error():
	for n in nail_parent.get_children():
		n.unlight()
	
func next_step():
	nail_parent.get_child(step).light_up()
	step += 1
