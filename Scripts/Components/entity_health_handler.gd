extends Node3D
class_name EntityHealthHandler

## Emitted when entity loses all Health points
## [br][param player] Player node reference
signal entity_died(entity: Node3D, handler: EntityHealthHandler);

## Emitted when entity loses some Health points
## [br][param player] Player node reference
signal entity_took_damage(entity: Node3D, handler: EntityHealthHandler);

## To emit when a new animation should be triggered. [br]
## Tell to the listener:[br][param new_state]: action single keyword -> for humans to understand the origin,[br]
## [param new_anims]: the list of animations -> in case one action can trigger various animations contextually,[br]
## [param anim_index]: the index of the animation to use from [param new_anims], [br]
## [param is_interruptible]: can this animation be interrupted while playing.
signal state_changed(new_state: String, new_anims: Array[Animation], anim_index: int, is_interruptible: bool)

@export_range(1, 200)
var max_health: float;

@export
var immunity_frame_duration: float;

## The list of animations that this component can trigger.[br]Used in [signal PlayerActionBase.state_changed].
@export
var animations: Array[Animation]

var health: float;
var current_immunity_frame_timer: float;
var is_immune_to_damage: bool = false;

func _ready() -> void:
	health = max_health;
	set_process(false);
	entity_died.connect(func _on_death(_entity, _handler): state_changed.emit("Death", animations, 0, false))

func _process(delta: float) -> void:
	current_immunity_frame_timer += delta;
	if current_immunity_frame_timer >= immunity_frame_duration:
		is_immune_to_damage = false;
		set_process(false);

func take_damage(entity: Node3D, amount: float) -> void:
	if is_immune_to_damage:
		return;

	if health <= 0.0:
		return;

	var new_health: float = health - amount;
	if new_health <= 0.0:
		health = 0.0;
		entity_died.emit(entity, self);
		return;
	
	health = new_health;
	enable_immunity();
	entity_took_damage.emit(entity, self);

func enable_immunity():
	# no duration - no immunity logic at all
	if immunity_frame_duration <= 0.0:
		return;

	is_immune_to_damage = true;
	current_immunity_frame_timer = 0;
	set_process(true);

func reset_health():
	health=max_health
