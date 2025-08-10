extends Area3D
class_name EntityDetectArea

signal entity_detected(entity: Node3D);
signal entity_lost(entity: Node3D);

func _ready() -> void:
	body_entered.connect(_on_body_entered);
	body_exited.connect(_on_body_exited);

func _exit_tree() -> void:
	body_entered.disconnect(_on_body_entered);
	body_exited.disconnect(_on_body_exited);

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Entity"):
		entity_detected.emit(body);

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Entity"):
		entity_lost.emit(body);
	