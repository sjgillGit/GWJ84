extends StateBase
class_name GasTurretDeactivated

@export
var animation_player: AnimationPlayer;

static func _get_state_name() -> String:
	return "gas_turret_deactivated";

func _on_enter() -> void:
	#animation_player.play("Shut_down"); [TODO]
	pass
