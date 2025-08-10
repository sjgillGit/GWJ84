extends StateBase
class_name GunTurretAttack;

@export
var entity_detector: EntityDetectArea;

@export
var animation_player: AnimationPlayer;

var target: Node3D;

static func _get_state_name() -> String:
	return "gun_turret_attack";

func _on_enter() -> void:
	entity_detector.entity_lost.connect(_on_entity_lost);

func _on_exit() -> void:
	entity_detector.entity_lost.connect(_on_entity_lost);

func _on_entity_lost(node: Node3D) -> void:
	if node != target:
		return;
	transition_to_state(GunTurretIdle._get_state_name());