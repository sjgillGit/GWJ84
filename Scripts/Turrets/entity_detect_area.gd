extends Area3D
class_name EntityDetectArea

signal entity_detected(entity: Node3D);
signal entity_lost(entity: Node3D);
signal target_changed(entity: Node3D);

var possible_targets: Array[Node3D] = [];
var tracked_target: Node3D;

func _ready() -> void:
	body_entered.connect(_on_body_entered);
	body_exited.connect(_on_body_exited);

func _exit_tree() -> void:
	body_entered.disconnect(_on_body_entered);
	body_exited.disconnect(_on_body_exited);

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Entity"):
		possible_targets.append(body);
		entity_detected.emit(body);

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Entity"):
		var target_index = possible_targets.find(body);
		if target_index == -1:
			return;
		possible_targets.remove_at(target_index);
		if tracked_target == body:
			try_pick_next_target();
		entity_lost.emit(body);

func enter_follow_target_mode(body: Node3D) -> void:
	var target_index = possible_targets.find(body);
	if target_index == -1:
		return;
	tracked_target = body;

func reset_follow_target_mode():
	tracked_target = null;

func try_pick_next_target():
	if possible_targets.size() == 0:
		tracked_target = null;
		return;

	var current_pos = global_position;
	var closest_idx = -1;
	var closest_distance = 2147483647;

	var idx = 0;
	for target in possible_targets:
		var distance_to_target = current_pos.distance_squared_to(target.global_position);
		if distance_to_target > closest_distance:
			continue;
		closest_idx = idx;
		closest_distance = distance_to_target;
		idx += 1;
	
	tracked_target = possible_targets[closest_idx];
	target_changed.emit(tracked_target);
