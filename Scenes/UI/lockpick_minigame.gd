extends Control
var lock_radius = 0.394
var sequence: Array = ["Z","left","right","down","up","left","right","down","up","P"]
var spin_spped = 10
var nail_spread: float
var start_angle = 180
@onready var middle: Node3D = $SubViewportContainer/SubViewport/Camera3D/middle
@onready var board: Node3D = $SubViewportContainer/SubViewport/Camera3D/board
const NAIL = preload("res://Scenes/UI/lockpick/nail.tscn")
@onready var nail_parent: Node3D = $SubViewportContainer/SubViewport/Camera3D/board/nail_parent
func _ready() -> void:
	nail_spread = 360 / sequence.size()
	for n in sequence.size():
		var nail_angle = start_angle - n * nail_spread
		var nail_position = get_nail_position(nail_angle)
		var nail_inst = NAIL.instantiate()
		nail_parent.add_child(nail_inst)
		nail_inst.position = nail_position
		nail_inst.set_nail(sequence[n],spin_spped)
		
func get_nail_position(angle:float):
	angle = fmod(angle,360)
	var x: float = lock_radius * cos(deg_to_rad(angle))
	var y: float = lock_radius * sin(deg_to_rad(angle))
	return Vector3(x,y,-0.902)
	
func _process(delta: float) -> void:
	if spin_spped != 0: board.rotation_degrees += Vector3(0,0,fmod((delta*spin_spped),360))
	if spin_spped != 0: middle.rotation_degrees += Vector3(0,0,-fmod((delta*spin_spped),360))
	#nail_parent.rotation_degrees += Vector3(0,0,fmod((delta*10),360))
