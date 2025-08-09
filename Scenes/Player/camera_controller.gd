extends Node3D
class_name CameraController

@export
var camera_horizontal: Node3D;

@export
var camera_vertical: Node3D;

@export
var vertical_min: float = -55;

@export
var vertical_max: float = 0;

var camera: Camera3D;

var horizontal_movement: float = 0.0;
var vertical_movement: float = 0.0;

var horizontal_sensitivity: float = 0.07;
var vertical_sensitivity: float = 0.07;

var horizontal_acceleration: float = 15;
var vertical_acceleration: float = 15;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return;
	event = event as InputEventMouseMotion;
	horizontal_movement += -event.relative.x * horizontal_sensitivity;
	vertical_movement += event.relative.y * vertical_sensitivity;
	vertical_movement = clamp(vertical_movement, vertical_min, vertical_max);
	

func _physics_process(delta: float) -> void:
	camera_horizontal.rotation_degrees.y = lerp(camera_horizontal.rotation_degrees.y, horizontal_movement, horizontal_acceleration * delta);
	camera_vertical.rotation_degrees.x = lerp(camera_vertical.rotation_degrees.x, vertical_movement, vertical_acceleration * delta);