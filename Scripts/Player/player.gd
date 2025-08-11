extends CharacterBody3D
class_name Player
@onready var control: Control = $CanvasLayer/Control

@export
var move_speed: float;

@export
var sprint_multiplier: float;

@export
var mesh_root: Node3D;

@export
var camera_controller: CameraController;

@export
var health_handler: EntityHealthHandler;

var gravity: float;

func _ready() -> void:
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(_delta: float) -> void:
	var input: Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack");
	var movement_direction : Vector3 = Vector3(input.x, 0.0, input.y).rotated(Vector3.UP, camera_controller.get_horizontal_rotation());
	
	if input != Vector2.ZERO:
		mesh_root.look_at(global_position + Vector3(movement_direction.x, 0, movement_direction.z));

	var movement_velocity = movement_direction * move_speed;
	if control.sprint == true:
		movement_velocity *= sprint_multiplier;

	self.velocity = Vector3(movement_velocity.x, -gravity, movement_velocity.z);
	self.move_and_slide();

func take_damage(damage: float) -> void:
	control.change_hp(-damage)
	health_handler.take_damage(self, damage);
