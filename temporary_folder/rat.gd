extends CharacterBody3D
class_name Rat
var speed = 10
var acceleration = 10 

@export var nav: NavigationAgent3D
@export var end_patrol_position: Marker3D
var begin_patrol_position: Vector3
var current_target: Vector3
var state:RatState
var can_attack: bool = true
var player

func _ready():
	begin_patrol_position = global_position
	current_target = end_patrol_position.global_position
	nav.target_desired_distance = 0.5
	nav.path_desired_distance = 0.5
	state = PatrolRatState.new(self)

func move_with_navmesh(delta,target_position):
	var direction = Vector3()
	# Navigation & movement
	nav.target_position = target_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, acceleration * delta)
	move_and_slide()

func patrol_behaviour(delta):
	move_with_navmesh(delta,current_target)

func chase_behaviour(delta):
	move_with_navmesh(delta,player.global_position)

func attack_behaviour(delta):
	move_and_slide()

func swarm_behaviour(delta):
	pass

func _physics_process(delta):
	state.on_physics_process(delta)



func flip_patrol_target():
	if current_target==begin_patrol_position:
		current_target = end_patrol_position.global_position
	else:
		current_target = begin_patrol_position

func _on_navigation_agent_3d_navigation_finished():
	state.on_navigation_agent_3d_navigation_finished()


func _on_player_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	state = ChaseRatState.new(self)
	current_target = body.global_position
	player = body
