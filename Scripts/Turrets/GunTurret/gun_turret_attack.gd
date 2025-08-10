extends StateBase
class_name GunTurretAttack;

@export
var entity_detector: EntityDetectArea;

@export
var animation_player: AnimationPlayer;

var target: Node3D;

func _get_state_name() -> String:
	return "gun_turret_attack";

func _on_enter() -> void:
	pass;

func _on_process(delta: float) -> void:
	pass;

func _on_exit() -> void:
	pass;