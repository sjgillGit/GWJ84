extends StateBase
class_name GunTurretIdle

@export
var entity_detector: EntityDetectArea;

@export
var animation_player: AnimationPlayer;

@export
var health_handler: EntityHealthHandler;

static func _get_state_name() -> String:
	return "gun_turret_idle";

func _on_enter() -> void:
	animation_player.play("Idle");
	entity_detector.entity_detected.connect(_on_entity_detected);
	health_handler.entity_died.connect(_on_death);

func _on_exit() -> void:
	entity_detector.entity_detected.disconnect(_on_entity_detected);
	health_handler.entity_died.disconnect(_on_death);

func _on_entity_detected(node: Node3D) -> void:
	transition_to_state(GunTurretAttack._get_state_name(), func(state: GunTurretAttack) -> void: state.target = node);

func _on_death() -> void:
	transition_to_state(GunTurretDeactivated._get_state_name());
