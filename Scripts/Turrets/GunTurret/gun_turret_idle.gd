extends StateBase
class_name GunTurretIdle

@export
var entity_detector: EntityDetectArea;

@export
var animation_player: AnimationPlayer;

static func _get_state_name() -> String:
	return "gun_turret_idle";

func _on_enter() -> void:
	animation_player.play("Idle");
	entity_detector.entity_detected.connect(_on_entity_detected);

func _on_exit() -> void:
	entity_detector.entity_detected.disconnect(_on_entity_detected);

func _on_entity_detected(node: Node3D) -> void:
	transition_to_state(GunTurretAttack._get_state_name(), func(state: GunTurretAttack) -> void: state.target = node);
