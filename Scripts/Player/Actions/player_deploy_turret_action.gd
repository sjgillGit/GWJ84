extends PlayerActionBase
class_name PlayerDeployTurrentAction
@onready var skill_box: HBoxContainer = $"../../CanvasLayer/skill_box"

@export
var deploy_cooldown: float;

var current_cooldown: float;
var can_be_performed: bool = true;

func _ready() -> void:
	set_process(false);

func _process(delta: float) -> void:
	current_cooldown -= delta;
	if current_cooldown <= 0.0:
		can_be_performed = true;
		set_process(false);

func _can_perform_action() -> bool:
	return can_be_performed;

func _perform_action() -> void:
	skill_box.deploy_perform(deploy_cooldown)
	current_cooldown = deploy_cooldown;
	can_be_performed = false;
	print("Turret deployed!");
	set_process(true);
