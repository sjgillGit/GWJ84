extends PlayerActionBase
class_name PlayerMeleeAction
@onready var skill_box: HBoxContainer = $"../../screen_ui/skill_box"

@export
var melee_cooldown: float;

@export
var shape_cast: ShapeCast3D;

@export
var damage: float;

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

	shape_cast.force_shapecast_update();

	for shape_info: Dictionary in shape_cast.collision_result:
		var collider = shape_info["collider"] as Node3D;
		if collider is not Npc:
			continue;
		collider = collider as Npc;
		collider.take_damage(damage);

	set_process(true);
