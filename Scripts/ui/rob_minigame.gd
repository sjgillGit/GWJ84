extends Control
var sequence: Array = ["Z","left","right","down","up","left","right","down","up","P"]
var nail_spread: float
var starting_x: =- 0.6
var step: int = 0
const NAIL = preload("res://Scenes/UI/lockpick/nail.tscn")
@onready var camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var nail_parent: Node3D = $SubViewportContainer/SubViewport/Camera3D/nail_parent
@onready var error_sfx: AudioStreamPlayer = $error
@onready var next_step_sfx: AudioStreamPlayer = $next_step
@onready var wrench_2: Node3D = $"SubViewportContainer/SubViewport/Camera3D/Wrench"

func stop():
	camera_3d.position = Vector3(0.005,-0.188,-0.076)
	for n in nail_parent.get_children():
		n.queue_free()
	step = 0
func start(speed):
	
	self.scale = Vector2(1,1) * GlobalSettings.multiplier
	camera_3d.position = Vector3(0,-100,0)
	var spin_spped = speed
	nail_spread = 200 / sequence.size()
	for n in sequence.size():
		var nail_position = get_nail_position(n)
		var nail_inst = NAIL.instantiate()
		nail_parent.add_child(nail_inst)
		nail_inst.position = nail_position
		nail_inst.set_nail(str(sequence[n]),spin_spped)
	await get_tree().process_frame
	nail_parent.get_child(0).first()
	
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
	error_sfx.play()
	var tween = get_tree().create_tween()
	tween.tween_property(wrench_2,"rotation_degrees",Vector3(-60,55,0),0.3).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(wrench_2,"rotation_degrees",Vector3(-90,0,0),0.3).set_trans(Tween.TRANS_CIRC)
	
	for n in nail_parent.get_children():
		n.unlight()
	step = 0
	if nail_parent.get_children().size() != 0: nail_parent.get_child(0).first()
func next_step():
	next_step_sfx.play()
	var tween = get_tree().create_tween()
	tween.tween_property(wrench_2,"rotation_degrees",Vector3(-100,-25,30),0.3).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(wrench_2,"rotation_degrees",Vector3(-90,0,0),0.3).set_trans(Tween.TRANS_CIRC)
	nail_parent.get_child(step).light_up()
	step += 1
	if !nail_parent.get_children().size() == step: nail_parent.get_child(step).first()
