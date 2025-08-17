extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func win() -> void:
	animation_player.play("Dance")
func death():
	animation_player.play("Death")
