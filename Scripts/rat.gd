extends CharacterBody3D
class_name Rat
var speed = 10
var acceleration = 10 
signal killed
@export var nav: NavigationAgent3D
@export var end_patrol_position: Marker3D
@export var attack_damage:int = 10
var begin_patrol_position: Vector3
var current_target: Vector3
var state:RatState
var can_attack: bool = true
var player
var leader 
var neighbors 
func _ready():
	begin_patrol_position = global_position
	current_target = end_patrol_position.global_position
	state = PatrolRatState.new(self)
	$EntityHealthHandler.entity_died.connect(_on_death)

func update_neighbors(new_neighbors):
	neighbors = new_neighbors

func flip_patrol_target():
	if current_target==begin_patrol_position:
		current_target = end_patrol_position.global_position
	else:
		current_target = begin_patrol_position

func get_separation_force():
	var separation_force = Vector3.ZERO
	var neighbor_count = 0
	for neighbor_rat in neighbors:
		var distance = (neighbor_rat.global_position - global_position).length()
		if distance > 0 and distance < 7.0:
			separation_force += (global_position - neighbor_rat.global_position).normalized()
			neighbor_count +=1
	if neighbor_count > 0:
		separation_force /= neighbor_count
	separation_force = separation_force.normalized() *speed
	return separation_force

func patrol_behaviour(delta):
	boid_calculation((current_target - global_position).normalized() * speed,delta)
	if abs(current_target.x + current_target.z - global_position.x - global_position.z) < 2:
		flip_patrol_target()
	move_and_slide()

func boid_calculation(seek_force,delta):
	var separation_force = get_separation_force()
	var alignment_force = get_alignment_force()
	var total_force = (seek_force * 2) + (separation_force * 8.0) + (alignment_force * 2.0)
	if velocity.length() > speed:
		total_force = total_force.normalized() * speed
	# Keep Y velocity for gravity
	velocity.y += -10 * delta  
	# Apply horizontal steering
	velocity.x = lerp(velocity.x, total_force.x, 0.01)
	velocity.z = lerp(velocity.z, total_force.z, 0.01)

func chase_behaviour(delta):
	boid_calculation((player.global_position - global_position).normalized()*speed,delta)
	if (player.global_position - global_position).length() < 5 and can_attack:
		player.take_damage(attack_damage)
		can_attack = false
		$cooldown_timer.start()

func get_alignment_force():
	var avg_velocity = Vector3.ZERO
	var count =0
	for other in neighbors:
		avg_velocity += other.velocity
		count +=1
	if count >0:
		avg_velocity /= count
		avg_velocity =  (avg_velocity.normalized()*speed) - velocity
	return avg_velocity

func swarm_behaviour(delta):
	boid_calculation((leader.global_position - global_position).normalized() * speed,delta)
	move_and_slide()

func _on_player_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	state = ChaseRatState.new(self)
	current_target = body.global_position
	player = body
	velocity = Vector3.ZERO

func start_in_swarm_status(assigned_leader):
	state = SwarmRatState.new(self)
	leader = assigned_leader
	leader.killed.connect(_on_leader_killed)

func start_in_leader_status():
	state = PatrolRatState.new(self)

func _on_cooldown_timer_timeout():
	can_attack = true

func take_damage(damage):
	$EntityHealthHandler.take_damage(self,damage)

func _on_leader_killed(leader,new_leader):
	leader=new_leader

func _on_death():
	var new_leader = null
	if neighbors.size() > 1:
		new_leader = neighbors[0]
		new_leader.start_in_leader_status()
	killed.emit(self,new_leader)
