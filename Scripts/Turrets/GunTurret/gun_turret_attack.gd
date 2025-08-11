extends StateBase
class_name GunTurretAttack;

@export
var entity_detector: EntityDetectArea;

@export
var animation_player: AnimationPlayer;

@export
var skeleton: Skeleton3D;

@export
var shoot_interval: float;

@export
var health_handler: EntityHealthHandler;

var target: Node3D;
var bone_idx: int;
var shoot_interval_timer: float;

static func _get_state_name() -> String:
	return "gun_turret_attack";

func _ready() -> void:
	bone_idx = skeleton.find_bone("central_bone");

func _on_enter() -> void:
	entity_detector.entity_lost.connect(_on_entity_lost);
	health_handler.entity_died.connect(_on_death);
	animation_player.stop();
	shoot_interval_timer = 0.0;

func _on_process(delta: float) -> void:
	look_at_target();
	shoot_at_target(delta);

func _on_exit() -> void:
	entity_detector.entity_lost.disconnect(_on_entity_lost);
	health_handler.entity_died.disconnect(_on_death);
	skeleton.clear_bones_global_pose_override();

func _on_entity_lost(node: Node3D) -> void:
	if node != target:
		return;
	transition_to_state(GunTurretIdle._get_state_name());


func _on_death() -> void:
	transition_to_state(GunTurretDeactivated._get_state_name());

func look_at_target() -> void:
	var bone_transform: Transform3D = skeleton.global_transform * skeleton.get_bone_global_pose(bone_idx);
	bone_transform = bone_transform.looking_at(target.global_position, Vector3.UP, true);
	var local_bone_transform: Transform3D = skeleton.global_transform.affine_inverse() * bone_transform;
	var bone_rotation: Quaternion = local_bone_transform.basis.get_rotation_quaternion();
	skeleton.set_bone_pose_rotation(bone_idx, bone_rotation);

func shoot_at_target(delta: float) -> void:
	shoot_interval_timer += delta;
	if shoot_interval_timer >= shoot_interval:
		print("turret shoots at the target");
		shoot_interval_timer = 0.0;