extends CharacterBody3D
class_name Rat
@export var speed = 10
@export var acceleration = 10 
@export var attack_radius = 5
signal killed
signal patrolling 
signal chasing 
signal attacking
@export var end_patrol_position: Marker3D
@export var attack_damage:int = 10
@onready  var raycasts = [
$Rat/raycasts/forward_raycast,
$Rat/raycasts/positive_45_raycast,
$Rat/raycasts/minus_45_raycast
]
var begin_patrol_position: Vector3
var current_target: Vector3
var state:RatState
var can_attack: bool = true
var player
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

func patrol_behaviour(delta):
	patrolling.emit()
	boid_calculation((current_target - global_position).normalized() * speed,delta)
	if abs(current_target.x + current_target.z - global_position.x - global_position.z) < 2:
		flip_patrol_target()

func chase_behaviour(delta):
	velocity = Vector3.ZERO
	chasing.emit()
	current_target = player.global_position
	boid_calculation((player.global_position - global_position).normalized()*speed,delta)
	if (player.global_position - global_position).length() < attack_radius:
		state = AttackRatState.new(self)

func attack_behaviour(delta):
	if can_attack:
		velocity = Vector3.ZERO
		$attack_cooldown_timer.start()
		attacking.emit()
		player.take_damage(attack_damage)
		can_attack = false

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


func get_avoidance_force():
	var avoidance_force = Vector3.ZERO
	for ray:RayCast3D in raycasts:
		if ray.is_colliding():
			var obstacle = ray.get_collider()
			var push_direction = (global_position - ray.get_collision_point()).normalized()
			var distance_factor = 1.0 - (ray.get_collision_point().distance_to(global_position)) / ray.target_position.length()
			avoidance_force += push_direction*distance_factor
	return avoidance_force

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


func boid_calculation(seek_force,delta):
	var separation_force = get_separation_force()
	var alignment_force = get_alignment_force()
	var avoidance_force = get_avoidance_force()
	#var break_force = Vector3.ZERO
	var total_force = (seek_force * 2.0) + (separation_force * 2.0) + (alignment_force * 1.0) + (avoidance_force * 1.5)
	if velocity.length() > speed:
		total_force = total_force.normalized() * speed
	# Keep Y velocity for gravity
	velocity.y += -10 * delta  
	# Apply horizontal steering
	velocity.x = lerp(velocity.x, total_force.x, 0.1)
	velocity.z = lerp(velocity.z, total_force.z, 0.1)
	var look_pos = Vector3(current_target.x, global_position.y, current_target.z)
	$Rat.look_at(look_pos, Vector3.UP)
	$Rat.rotate_y(PI)
	move_and_slide()

func _on_player_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	state.try_chase_player(body_rid, body, body_shape_index, local_shape_index)

func chase_player(body_rid, body, body_shape_index, local_shape_index):
	state = ChaseRatState.new(self)
	current_target = body.global_position
	player = body
	velocity = Vector3.ZERO

func start_in_leader_status():
	state = PatrolRatState.new(self)

func _on_cooldown_timer_timeout():
	state.try_restart_attack()

func restart_attack():
	can_attack = true
	state = ChaseRatState.new(self)

func take_damage(damage):
	$EntityHealthHandler.take_damage(self,damage)

func get_stunned():
	state = StunnedRatState.new(self,state)
	$stunned_cooldown.start()
	$Rat/AnimationPlayer.play("Stunned")

func _on_death():
	velocity = Vector3.ZERO




func _on_animation_player_death_animation_finished():
	killed.emit(self)


func _on_stunned_cooldown_timeout():
	state=state.get_previous_state()
