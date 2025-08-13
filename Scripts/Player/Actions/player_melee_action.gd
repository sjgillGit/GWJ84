extends PlayerActionBase
class_name PlayerMeleeAction
@onready var skill_box: HBoxContainer = $"../../CanvasLayer/skill_box"

@export
var melee_cooldown: float;

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
	skill_box.meleeaction_performed(melee_cooldown)
	state_changed.emit("Attack", animations, 0, false)
	current_cooldown = melee_cooldown;
	can_be_performed = false;
	print("Melee action performed");
	set_process(true);
