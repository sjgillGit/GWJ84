@tool
extends FieldObjectiveBase
class_name DefendPositionObjective

@export
var defend_for_time: float;

var time_passed: float;

func _ready() -> void:
	set_process(false);

func _process(delta: float) -> void:
	time_passed += delta;
	if time_passed >= defend_for_time:
		set_process(false);
		_emit_objective_completed();

func _on_player_entered():
	if is_complete:
		return;
	set_process(true);

func _on_player_left():
	if is_complete:
		return;
	set_process(false);
