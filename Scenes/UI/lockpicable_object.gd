extends Node3D
var close: bool = false
@onready var field_objective_base: EnterCombinationObjective = $FieldObjectiveBase
@onready var lock: Control = $lock_layer/lock
@onready var lock_layer: CanvasLayer = $lock_layer
@export var speed: float
var opened: bool = false
var combination


func _ready() -> void:
	GlobalSignals.enter_combination_objective_available.connect(Callable(self, "on_close_up"))
	GlobalSignals.enter_combination_objective_unavailable.connect(Callable(self, "on_close_up"))
	GlobalSignals.objective_completed.connect(Callable(self, "on_win"))
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") && close == true && opened == false:
		field_objective_base.start_objective_progress()
		opened = true
		lock.sequence = combination
		lock.start(speed)
		lock_layer.visible = true

func on_close_up(objective):
	opened = false
	close = true
	combination = objective.combination
	
func on_far_away(objective):
	opened = false
	close = false
	lock.error()
	lock_layer.visible = false

func _on_field_objective_base_player_input_error() -> void:
	lock.error()

func _on_field_objective_base_player_input_made_progress() -> void:
	lock.next_step()
func on_win(objective):
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	on_far_away(objective)
	self.queue_free()
	
