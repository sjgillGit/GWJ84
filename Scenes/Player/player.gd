extends CharacterBody3D
class_name Player

@export
var move_speed: float;

@export
var sprint_multiplier: float;

@export 
var camera: Camera3D;

@export
var modelRoot: Node3D;

func _physics_process(_delta: float) -> void:
	var input: Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack");
	if input == Vector2.ZERO:
		return;

	var movement_direction : Vector3 = Vector3(input.x, 0.0, input.y).rotated(Vector3.UP, $CameraRoot/CameraHorizontal.rotation.y);
	modelRoot.look_at(global_position + Vector3(movement_direction.x, 0, movement_direction.z));

	var movement_velocity = movement_direction * move_speed;
	if Input.is_action_pressed("Sprint"):
		movement_velocity *= sprint_multiplier;

	self.velocity = Vector3(movement_velocity.x, -0.98, movement_velocity.z);
	self.move_and_slide();
