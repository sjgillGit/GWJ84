extends Node3D
var close: bool = false
@onready var field_objective_base: EnterCombinationObjective = $FieldObjectiveBase
@onready var robbery: Control = $rob_layer/robbery
@onready var rob_layer: CanvasLayer = $rob_layer
@export var level: int
var opened: bool = false
var combination
var won: bool
signal win
signal far
@onready var interact_indication: Node3D = $"../interact_indication"

func start() -> void:
	var bonus_keys : Array[int] = [KEY_F, KEY_9, KEY_L, KEY_Z, KEY_9, KEY_Y, KEY_X, KEY_P, KEY_M, KEY_N];
	bonus_keys.shuffle()
	for n in min(level,10):
		field_objective_base.possible_keys.append(bonus_keys.pop_back())
	field_objective_base.generate_combination();
	GlobalSignals.enter_combination_objective_available.connect(Callable(self, "on_close_up"))
	GlobalSignals.enter_combination_objective_unavailable.connect(Callable(self, "on_far_away"))
	GlobalSignals.objective_completed.connect(Callable(self, "on_win"))
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") && close == true && opened == false:
		interact_indication.hide_ind()
		field_objective_base.start_objective_progress()
		opened = true
		robbery.sequence = combination
		robbery.start(0)
		rob_layer.visible = true

func on_close_up(objective):
	if objective != field_objective_base:
		GlobalSignals.enter_combination_objective_unavailable.emit(field_objective_base)
		return
	opened = false
	close = true
	combination = objective.combination
	interact_indication.show_ind()
func on_far_away(objective):
	field_objective_base.set_process_unhandled_key_input(false)
	if objective != field_objective_base:
		return
	robbery.stop()
	opened = false
	close = false
	interact_indication.hide_ind()
	#if !won: robbery.error()
	rob_layer.visible = false

func _on_field_objective_base_player_input_error() -> void:
	robbery.error()

func _on_field_objective_base_player_input_made_progress() -> void:
	robbery.next_step()
func on_win(objective):
	if objective != field_objective_base:
		return
	won = true
	var timer = get_tree().create_timer(0.6)
	await timer.timeout
	robbery.stop()
	self.queue_free()
	win.emit()
