@tool
extends FieldObjectiveBase
class_name EnterCombinationObjective

signal player_input_error();
signal player_input_made_progress();

static var possible_keys: Array[int] = [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT];

var combination: Array[int];
var current_input_idx: int;

func _ready() -> void:
	super._ready();
	set_process_unhandled_key_input(false);
	if Engine.is_editor_hint():
		return;
	generate_combination();

func _unhandled_key_input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return;
	event = event as InputEventKey;
	var next_value = combination[current_input_idx];
	if event.keycode != next_value:
		current_input_idx = 0;
		player_input_error.emit();
		return;
	current_input_idx += 1;
	if current_input_idx >= combination.size():
		_emit_objective_completed();
		set_process_unhandled_key_input(false);
	else:
		player_input_made_progress.emit();

func _on_player_entered():
	GlobalSignals.enter_combination_objective_available.emit(self);

func _on_player_left():
	GlobalSignals.enter_combination_objective_unavailable.emit(self);

func start_objective_progress():
	set_process_unhandled_key_input(true);

func generate_combination():
	combination = [];
	var rng = RandomNumberGenerator.new();
	for i in range(0, 10):
		combination[i] = possible_keys[rng.randi_range(0, possible_keys.size())];