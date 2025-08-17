extends PlayerActionBase
class_name PlayerDeployTurrentAction
@onready var skill_box: HBoxContainer = $"../../screen_ui/skill_box"

@export
var deploy_cooldown: float;

@export
var player_reference: Player;

@export
var turret_scene: PackedScene;

@export
var max_distance_to_place_turrets: float;

var current_cooldown: float;
var can_be_performed: bool = true;
var raycast_params: PhysicsRayQueryParameters3D;
var turrets_node: Node;

func _ready() -> void:
	raycast_params = PhysicsRayQueryParameters3D.new();
	raycast_params.collide_with_bodies = true;
	raycast_params.collide_with_areas = false;
	turrets_node = player_reference.get_parent().get_node("turrets")
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
	GlobalSettings.towers_deployed += 1
	skill_box.deploy_perform(deploy_cooldown)
	state_changed.emit("Turret", animations, 0, false)
	current_cooldown = deploy_cooldown;
	can_be_performed = false;
	set_process(true);

func _try_deploy_turret() -> bool:
	var target_point: Vector3 = player_reference.camera_controller.camera.global_position - player_reference.camera_controller.camera.global_transform.basis.z * max_distance_to_place_turrets;
	var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state;
	raycast_params.from = player_reference.camera_controller.camera.global_position;
	raycast_params.to = target_point;
	var raycast = space.intersect_ray(raycast_params);
	if raycast.has("collider"):
		var turret_scene_instance: Node3D = turret_scene.instantiate();
		turret_scene_instance.position = raycast.position;
		turrets_node.add_child(turret_scene_instance);
		return true;
	else:
		raycast_params.from = target_point;
		raycast_params.to = target_point + Vector3.DOWN * 20;
		var downward_raycast = space.intersect_ray(raycast_params);
		if downward_raycast.has("collider"):
			var turret_scene_instance: Node3D = turret_scene.instantiate();
			turret_scene_instance.position = downward_raycast.position;
			turrets_node.add_child(turret_scene_instance);
			return true;
	return false;
