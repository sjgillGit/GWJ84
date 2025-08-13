extends HBoxContainer
@onready var player_melee_action: PlayerMeleeAction = $"../../PlayerActions/PlayerMeleeAction"
@onready var player_deploy_turrent_action: PlayerDeployTurrentAction = $"../../PlayerActions/PlayerDeployTurrentAction"
@onready var skillbutton: Control = $skillbutton
@onready var control: Control = $Control

func _ready() -> void:
	skillbutton.cooldown = player_melee_action.melee_cooldown
	control.cooldown = player_deploy_turrent_action.deploy_cooldown
	skillbutton.fill_button(player_melee_action.melee_cooldown,skillbutton.input_name)

func meleeaction_performed(cooldown):
	skillbutton.skill_activate(cooldown)

func deploy_perform(cooldown):
	control.skill_activate(cooldown)
