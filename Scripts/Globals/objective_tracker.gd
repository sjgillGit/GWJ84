extends Node

enum FieldObjectiveBaseState 
{
	NON_COMPLETED,
	COMPLETED
}

signal all_objectives_completed();
signal objective_completed(objective: FieldObjectiveBase);

var current_objectives: Dictionary[FieldObjectiveBase, FieldObjectiveBaseState];

func clear_objective_info():
	if current_objectives == null:
		return;
	for obj in current_objectives:
		obj.objective_completed.disconnect(_handle_objective_completed);

func handle_level_initialization():
	current_objectives = {};
	for objective: FieldObjectiveBase in get_tree().get_nodes_in_group("FieldObjective"):
		current_objectives[objective] = FieldObjectiveBaseState.NON_COMPLETED;
		objective.objective_completed.connect(_handle_objective_completed);

func _handle_objective_completed(objective: FieldObjectiveBase):
	current_objectives[objective] = FieldObjectiveBaseState.COMPLETED;
	objective.objective_completed.disconnect(_handle_objective_completed);
	objective_completed.emit(objective);
	if current_objectives.values().all(func (state: FieldObjectiveBaseState): return state == FieldObjectiveBaseState.COMPLETED):
		all_objectives_completed.emit();