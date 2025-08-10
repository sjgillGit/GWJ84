extends CharacterBody3D

var speed = 10
var acceleration = 10 

@export var nav: NavigationAgent3D
@export var end_patrol_position: Marker3D
var begin_patrol_position: Vector3
var current_target: Vector3

enum State { PATROL, CHASE, ATTACK }
var state = State.PATROL
var can_attack: bool = true
var player

func _ready():
	begin_patrol_position = global_position
	current_target = end_patrol_position.global_position
	nav.target_desired_distance = 0.5
	nav.path_desired_distance = 0.5

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

func _physics_process(delta):
	match state:
		State.PATROL:
			patrol_behaviour(delta)
		State.CHASE:
			chase_behaviour(delta)
		State.ATTACK:
			attack_behaviour(delta)
	





func _on_navigation_agent_3d_navigation_finished():
	if state == State.PATROL:
		if current_target==begin_patrol_position:
			current_target = end_patrol_position.global_position
		else:
			current_target = begin_patrol_position
	elif state == State.CHASE:
		speed = 10


func _on_player_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	state =  State.CHASE
	current_target = body.global_position
	player = body
		
