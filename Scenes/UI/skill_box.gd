extends HBoxContainer
@onready var player_melee_action: PlayerMeleeAction = $"../../PlayerActions/PlayerMeleeAction"
@onready var player_deploy_turrent_action: PlayerDeployTurrentAction = $"../../PlayerActions/PlayerDeployTurrentAction"
@onready var control: Control = $Control

func _ready() -> void:
	control.cooldown = player_deploy_turrent_action.deploy_cooldown

func meleeaction_performed(cooldown):
	control.skill_activate(cooldown)

func deploy_perform(cooldown):
	control.skill_activate(cooldown)
