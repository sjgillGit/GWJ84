extends HBoxContainer

@onready var control: Control = $Control

@export
var player_actions: PlayerActions;

func meleeaction_performed(cooldown: float) -> void:
	control.skill_activate(cooldown);

func deploy_perform(cooldown: float) -> void:
	control.skill_activate(cooldown);

func action_performed(_action: PlayerActionBase, _index: int, scroll_type: PlayerActions.PlayerActionScrollType) -> void:
	if scroll_type == PlayerActions.PlayerActionScrollType.UP:
		
		control.scroll_down();
	else:
		control.scroll_up();
