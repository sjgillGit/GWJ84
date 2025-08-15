extends HBoxContainer

@onready var player_melee_action: PlayerMeleeAction = $"../../PlayerActions/PlayerMeleeAction"
@onready var player_deploy_turrent_action: PlayerDeployTurrentAction = $"../../PlayerActions/PlayerDeployTurrentAction"
@onready var control: Control = $Control

@export
var player_actions: PlayerActions;

func _ready() -> void:
	control.cooldown = player_deploy_turrent_action.deploy_cooldown
	player_actions.selected_action_changed.connect(on_selected_action_changed);

func meleeaction_performed(cooldown: float) -> void:
	control.skill_activate(cooldown);

func deploy_perform(cooldown: float) -> void:
	control.skill_activate(cooldown);

func on_selected_action_changed(_action: PlayerActionBase, _index: int, scroll_type: PlayerActions.PlayerActionScrollType) -> void:
	if scroll_type == PlayerActions.PlayerActionScrollType.UP:
		control.scroll_up();
	else:
		control.scroll_down();
