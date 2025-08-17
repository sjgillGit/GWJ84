extends CharacterBody3D
class_name Player

@onready var control: Control = $screen_ui/Control

## To emit when a new animation should be triggered. [br]
## Tell to the listener:[br][param new_state]: action single keyword -> for humans to understand the origin,[br]
## [param new_anims]: the list of animations -> in case one action can trigger various animations contextually,[br]
## [param anim_index]: the index of the animation to use from [param new_anims], [br]
## [param is_interruptible]: can this animation be interrupted while playing.
signal state_changed(new_state: String, new_anims: Array[Animation], anim_index: int, is_interruptible: bool)

@export
var move_speed: float;

@export
var sprint_multiplier: float;

@export
var mesh_root: Node3D;

@export
var camera_controller: CameraController;

@export
var health_handler: EntityHealthHandler;

@export
var anim_player: AnimationPlayer;
## The list of animations that this component can trigger.[br]Used in [signal PlayerActionBase.state_changed].
@export
var animations: Array[Animation]

var previous_state: String

var is_waiting_animation_end: bool = false

var gravity: float;

var is_alive: bool = true

@export var dead_scene:PackedScene
func _ready() -> void:
	is_alive = true
	state_changed.connect(_on_state_changed)
	var actions: Array[PlayerActionBase] = %PlayerActions.actions
	for i in actions:
		i.state_changed.connect(_on_state_changed)
	anim_player.animation_finished.connect(func _on_animation_finished(_bool): is_waiting_animation_end = false)
	health_handler.state_changed.connect(_on_state_changed)
	health_handler.entity_died.connect(_on_player_death)
	anim_player.play("Idle")
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

func _physics_process(_delta: float) -> void:
	if !is_alive:
		return
	var input: Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack");
	var movement_direction : Vector3 = Vector3(input.x, 0.0, input.y).rotated(Vector3.UP, camera_controller.get_horizontal_rotation());
	
	var movement_velocity = movement_direction * move_speed;
	if input != Vector2.ZERO:
		mesh_root.look_at(global_position + Vector3(movement_direction.x, 0.0, movement_direction.z), Vector3.UP, true);
		if control.sprint:
			movement_velocity *= sprint_multiplier;
			state_changed.emit("Run", animations, 2)
		else:
			state_changed.emit("Walk", animations, 1)
	else:
		state_changed.emit("Idle", animations, 0)

	self.velocity = Vector3(movement_velocity.x, -gravity, movement_velocity.z);
	self.move_and_slide();

func take_damage(damage: float) -> void:
	control.change_hp(-damage)
	health_handler.take_damage(self, damage)
	if health_handler.health < 0:
		get_tree().change_scene_to_file("res://Scenes/map.tscn")



func _on_state_changed(new_state, anims, index = 0, can_be_interrupt = true) -> void:
	if anims.is_empty():
		printerr("The animations' array from the signal's emitter is empty.")
	
	var new_animation: Animation = anims[index]
	var path: String = new_animation.resource_path
	var file: String = path.right(path.length() - path.rfind("/") - 1)
	var file_name: String = file.left(file.find("."))
	if new_state != previous_state or file_name != anim_player.assigned_animation:
		if is_waiting_animation_end and new_state != "Death":
			return
		anim_player.play(file_name, 0.3)
		previous_state = new_state
		is_waiting_animation_end = !can_be_interrupt

func _on_player_death(_entity, _handler) -> void:
	is_alive = false
	var death_timer := Timer.new()
	add_child(death_timer)
	death_timer.one_shot
	death_timer.start(2.5)
	death_timer.timeout.connect(func _on_timer_timeout(): get_tree().change_scene_to_packed(dead_scene))
	
