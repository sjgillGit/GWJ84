extends StateBase
class_name GasTurretIdle

@export
var entity_detector: EntityDetectArea;

@export
var animation_player: AnimationPlayer;

@export
var health_handler: EntityHealthHandler;

static func _get_state_name() -> String:
	return "gas_turret_idle";

func _on_enter() -> void:
	#animation_player.play("Idle"); [TODO]
	entity_detector.entity_detected.connect(_on_entity_detected);
	health_handler.entity_died.connect(_on_death);

func _on_exit() -> void:
	entity_detector.entity_detected.disconnect(_on_entity_detected);
	health_handler.entity_died.disconnect(_on_death);

func _on_entity_detected(node: Node3D) -> void:
	entity_detector.enter_follow_target_mode(node);
	transition_to_state(GasTurretAttack._get_state_name(), func(state: GasTurretAttack) -> void: state.target = node);

func _on_death(_entity: Node3D, _handler: EntityHealthHandler) -> void:
	transition_to_state(GasTurretDeactivated._get_state_name());
