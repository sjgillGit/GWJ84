extends PlayerActionBase
class_name PlayerDeployTurrentAction

@export
var deploy_cooldown: float;

@export
var player_reference: Player;

@export
var turret_scene: PackedScene;

var current_cooldown: float;
var can_be_performed: bool = true;
var raycast_params: PhysicsRayQueryParameters3D;

func _ready() -> void:
	raycast_params = PhysicsRayQueryParameters3D.new();
	raycast_params.collide_with_bodies = true;
	raycast_params.collide_with_areas = false;
	set_process(false);

func _process(delta: float) -> void:
	current_cooldown -= delta;
	if current_cooldown <= 0.0:
		can_be_performed = true;
		set_process(false);

func _can_perform_action() -> bool:
	return can_be_performed;

func _perform_action() -> void:
	if !_try_deploy_turret():
		return;
	current_cooldown = deploy_cooldown;
	can_be_performed = false;
	print("Turret deployed!");
	set_process(true);

func _try_deploy_turret() -> bool:
	raycast_params.from = player_reference.camera_controller.camera.global_position;
	raycast_params.to = player_reference.camera_controller.camera.global_position - player_reference.camera_controller.camera.global_transform.basis.z * 100;
	var raycast = get_world_3d().direct_space_state.intersect_ray(raycast_params);
	if raycast.has("collider"):
		var turret_scene_instance: Node3D = turret_scene.instantiate();
		turret_scene_instance.position = raycast.position;
		player_reference.get_parent().add_child(turret_scene_instance);
		return true;
	return false;