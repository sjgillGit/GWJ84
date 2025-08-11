extends StateBase
class_name GunTurretAttack;

@export
var entity_detector: EntityDetectArea;

@export
var animation_player: AnimationPlayer;

@export
var skeleton: Skeleton3D;

var target: Node3D;
var bone_idx: int;
var bone_default_position: Vector3;

static func _get_state_name() -> String:
	return "gun_turret_attack";

func _ready() -> void:
	bone_idx = skeleton.find_bone("central_bone");
	bone_default_position = skeleton.get_bone_pose_position(bone_idx);

func _on_enter() -> void:
	entity_detector.entity_lost.connect(_on_entity_lost);
	animation_player.stop();
	bone_default_position = skeleton.get_bone_pose_position(bone_idx);

func _on_process(_delta: float):
	var bone_transform: Transform3D = skeleton.global_transform * skeleton.get_bone_global_pose(bone_idx);
	bone_transform = bone_transform.looking_at(target.global_position, Vector3.UP, true);
	var local_bone_transform: Transform3D = skeleton.global_transform.affine_inverse() * bone_transform;
	var bone_rotation: Quaternion = local_bone_transform.basis.get_rotation_quaternion();
	skeleton.set_bone_pose_rotation(bone_idx, bone_rotation);

func _on_exit() -> void:
	entity_detector.entity_lost.disconnect(_on_entity_lost);
	skeleton.clear_bones_global_pose_override();

func _on_entity_lost(node: Node3D) -> void:
	if node != target:
		return;
	transition_to_state(GunTurretIdle._get_state_name());