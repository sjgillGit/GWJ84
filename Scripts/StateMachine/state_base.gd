extends Node3D
class_name StateBase

var state_machine: StateMachine;

static func _get_state_name():
	return "";

func _on_enter() -> void:
	pass;

func _on_process(delta: float) -> void:
	pass;

func _on_exit() -> void:
	pass;

func transition_to_state(state_name: String, before_enter_callback: Callable = Callable()) -> void:
	state_machine.transition_to_state(state_name, before_enter_callback);
