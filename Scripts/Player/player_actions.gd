extends Node3D
class_name PlayerActions

signal selected_action_changed(action: PlayerActionBase, index: int);

var actions: Array[PlayerActionBase];
var current_action_index: int = 0;

func _ready() -> void:
	actions.assign(get_children().filter(func (child): return child is PlayerActionBase));
	#try_activate_current_action();

func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return;
	
	event = event as InputEventMouseButton;
	if event.is_action_pressed("PerformAction"):
		try_activate_current_action();
	elif event.is_action_pressed("ScrollActionUp"):
		scroll_selection_action_up();
	elif event.is_action_pressed("ScrollActionDown"):
		scroll_selection_action_down();

func try_activate_current_action():
	var action = actions[current_action_index];
	if !action._can_perform_action():
		return;
	action._perform_action();

func scroll_selection_action_up():
	var next_index = current_action_index - 1;
	if next_index <= 0:
		next_index = actions.size() - 1;
	update_selected_index(next_index);

func scroll_selection_action_down():
	var next_index = current_action_index + 1;
	if next_index >= actions.size():
		next_index = 0;
	update_selected_index(next_index);

func update_selected_index(next_index: int):
	if current_action_index == next_index:
		return;
	current_action_index = next_index;
	selected_action_changed.emit(actions[current_action_index], current_action_index);
