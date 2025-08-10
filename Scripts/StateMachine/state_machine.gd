extends Node3D
class_name StateMachine

@export
var initial_state: StateBase

var states: Dictionary[String, StateBase];
var current_state: StateBase;
var next_state: StateBase

func _ready() -> void:
	states = {};
	for state in get_children().filter(func(x): return x is StateBase):
		state.state_machine = self;
		states[state._get_state_name()] = state;
	current_state = initial_state;
	current_state._on_enter();

func _physics_process(delta: float) -> void:
	if next_state != null:
		current_state._on_exit();
		current_state = next_state;
		current_state._on_enter();
		next_state = null;
	current_state._on_process(delta);

func transition_to_state(state_name: String, before_enter_callback: Callable = Callable()) -> void:
	var state = states.get(state_name);
	if state == null:
		printerr("State was not found %S" % state_name);
		return;
	if before_enter_callback.is_valid():
		before_enter_callback.call(state);
	next_state = state;
