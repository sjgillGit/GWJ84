extends Control
var lock_radius = 0.394
var sequence: Array = ["Z","left","right","down","up","left","right","down","up","P"]
var spin_spped = 0
var nail_spread: float
var step: int = 0
var start_angle = 150
@onready var board: Node3D = $SubViewportContainer/SubViewport/Camera3D/board
@onready var middle: Node3D = $SubViewportContainer/SubViewport/Camera3D/middle
@onready var nail_parent: Node3D = $SubViewportContainer/SubViewport/Camera3D/board/nail_parent
@onready var camera_3d: Camera3D = $SubViewportContainer/SubViewport/Camera3D

@onready var error_sfx: AudioStreamPlayer = $error
@onready var next_step_sfx: AudioStreamPlayer = $next_step
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer

const NAIL = preload("res://Scenes/UI/lockpick/nail.tscn")
func stop():
	camera_3d.position = Vector3(0.005,-0.188,-0.076)
	for n in nail_parent.get_children():
		n.queue_free()
	step = 0
func start(speed):
	self.scale = Vector2(1,1) * GlobalSettings.multiplier
	camera_3d.position = Vector3(0.005,-100.188,-0.076)
	board.rotation_degrees = Vector3(0,0,0)
	middle.rotation_degrees = Vector3(0,0,0)
	spin_spped = speed
	nail_spread = 360 / sequence.size()
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
	error_sfx.play()
	for n in nail_parent.get_children():
		n.unlight()
	var tween = get_tree().create_tween()
	tween.tween_property(middle,"rotation_degrees",Vector3(0,0,0),0.1*step).set_trans(Tween.TRANS_CIRC)
	step = 0
	if nail_parent.get_children().size() != 0: nail_parent.get_child(0).first()
func next_step():
	next_step_sfx.play()
	nail_parent.get_child(step).light_up()
	step += 1
	var tween = get_tree().create_tween()
	tween.tween_property(middle,"rotation_degrees",-step * Vector3(0,0,nail_spread),0.3).set_trans(Tween.TRANS_CIRC)
	if !nail_parent.get_children().size() == step: nail_parent.get_child(step).first()
