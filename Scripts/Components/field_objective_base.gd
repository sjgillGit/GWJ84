@tool
extends Node3D
class_name FieldObjectiveBase

signal objective_completed(objective: FieldObjectiveBase);

var player_detector: Area3D;

func _ready() -> void:
	if Engine.is_editor_hint():
		update_configuration_warnings();
		child_order_changed.connect(_on_child_order_changed);
	else:
		var area = get_children().filter(func(child): return child is Area3D)[0] as Area3D;
		area.body_entered.connect(_on_player_entered_internal);
		area.body_exited.connect(_on_player_exited_internal);

func _on_player_entered():
	pass;

func _on_player_left():
	pass;

func _on_player_entered_internal(_body: Node3D):
	_on_player_entered();

func _on_player_exited_internal(_body: Node3D):
	_on_player_left();

func _get_configuration_warnings() -> PackedStringArray:
	if !get_children().any(func(child) -> bool: return child is Area3D):
		return ["Must contain at least one Area3D node to work"];
	return [];

func _on_child_order_changed():
	update_configuration_warnings();