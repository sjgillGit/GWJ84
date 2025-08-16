extends StateBase
class_name GasTurretAttack;

@export
var entity_detector: EntityDetectArea;

@export
var animation_player: AnimationPlayer;

@export
var gas_emittor: GasEmitter;

@export
var gas_duration: float

@export
var shoot_interval: float;

@export
var health_handler: EntityHealthHandler;

var target: Node3D;
var bone_idx: int;
var shoot_interval_timer: float;
var gas_duration_timer: float

static func _get_state_name() -> String:
	return "gas_turret_attack";

func _ready() -> void:
	pass

func _on_enter() -> void:
	entity_detector.entity_lost.connect(_on_entity_lost);
	entity_detector.target_changed.connect(_on_entity_target_changed);
	health_handler.entity_died.connect(_on_death);
	animation_player.stop();
	shoot_interval_timer = 0.0;
	gas_duration_timer = 0.0
	gas_emittor.current_emitter.emitting = true

func _on_process(delta: float) -> void:
	shoot_at_target(delta);

func _on_exit() -> void:
	entity_detector.entity_lost.disconnect(_on_entity_lost);
	entity_detector.target_changed.disconnect(_on_entity_target_changed);
	health_handler.entity_died.disconnect(_on_death);

func _on_entity_lost(node: Node3D) -> void:
	if node != target:
		return;
	transition_to_state(GasTurretIdle._get_state_name());

func _on_entity_target_changed(node: Node3D) -> void:
	target = node;

func _on_death(_entity: Node3D, _handler: EntityHealthHandler) -> void:
	transition_to_state(GasTurretDeactivated._get_state_name());

func shoot_at_target(delta: float) -> void:
	shoot_interval_timer += delta;
	if shoot_interval_timer >= shoot_interval:
		print("turret gas at the target");
		#assert(target.is_in_group("take_damage"), "Target has no take_damage method");
		#target.take_damage(100)
		# [TODO] Stun target.is_in_group("stun")
		shoot_interval_timer = 0.0;
	
	assert(gas_emittor.current_emitter.emitting == true)
	gas_duration_timer += delta
	if gas_duration_timer >= gas_duration:
		gas_emittor.current_emitter.emitting = false
		gas_duration_timer = 0.0
