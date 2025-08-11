extends StateBase
class_name GunTurretDeactivated

@export
var animation_player: AnimationPlayer;

static func _get_state_name() -> String:
	return "gun_turret_deactivated";

func _on_enter() -> void:
	animation_player.play("Shut_down");