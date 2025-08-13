extends Control
var lock_radius = 0.394
var sequence: Array = ["Z","left","right","down","up","left","right","down","up","P"]
var spin_spped = 0
var nail_spread: float
var step: int = 0
var start_angle = 150
@onready var middle: Node3D = $SubViewportContainer/SubViewport/middle
@onready var nail_parent: Node3D = $SubViewportContainer/SubViewport/board/nail_parent
@onready var board: Node3D = $SubViewportContainer/SubViewport/board

const NAIL = preload("res://Scenes/UI/lockpick/nail.tscn")
func start(speed):
	board.rotation_degrees = Vector3(0,0,0)
	middle.rotation_degrees = Vector3(0,0,0)
	spin_spped = speed
	nail_spread = 360 / sequence.size()
	for n in nail_parent.get_children():
		n.queue_free()
	for n in sequence.size():
		var nail_angle = start_angle - n * nail_spread
		var nail_position = get_nail_position(nail_angle)
		var nail_inst = NAIL.instantiate()
		nail_parent.add_child(nail_inst)
		nail_inst.position = nail_position
		nail_inst.set_nail(str(sequence[n]),spin_spped)
	await get_tree().process_frame
	nail_parent.get_child(0).first()
		
func get_nail_position(angle:float):
	angle = fmod(angle,360)
	var x: float = lock_radius * cos(deg_to_rad(angle))
	var y: float = lock_radius * sin(deg_to_rad(angle))
	return Vector3(x,y,-0.902)
	
func _process(delta: float) -> void:
	if spin_spped != 0: board.rotation_degrees += Vector3(0,0,-fmod((delta*spin_spped),360))
func error():
	for n in nail_parent.get_children():
		n.unlight()
	print("uwu")
	var tween = get_tree().create_tween()
	tween.tween_property(middle,"rotation_degrees",Vector3(0,0,0),0.1*step).set_trans(Tween.TRANS_CIRC)
	step = 0
	nail_parent.get_child(0).first()
func next_step():
	nail_parent.get_child(step).light_up()
	step += 1
	var tween = get_tree().create_tween()
	tween.tween_property(middle,"rotation_degrees",-step * Vector3(0,0,nail_spread),0.3).set_trans(Tween.TRANS_CIRC)
	if !nail_parent.get_children().size() == step: nail_parent.get_child(step).first()
