extends Node3D
class_name EntityHealthHandler

## Emitted when entity loses all Health points
## [br][param player] Player node reference
signal entity_died(entity: Node3D, handler: EntityHealthHandler);

## Emitted when entity loses some Health points
## [br][param player] Player node reference
signal entity_took_damage(entity: Node3D, handler: EntityHealthHandler);

@export_range(1, 100)
var max_health: float;

var health: float;

func take_damage(entity: Node3D, amount: float) -> void:
	if health <= 0.0:
		return;

	var new_health: float = health - amount;

	if new_health <= 0.0:
		health = 0.0;
		entity_died.emit(entity, self);
		return;
	
	health = new_health;
	entity_took_damage.emit(entity, self);