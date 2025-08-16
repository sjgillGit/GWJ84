extends CharacterBody3D
class_name Npc
@export var speed = 10
@export var acceleration = 10 
@export var attack_radius = 5
signal entity_died
signal killed
signal patrolling 
signal chasing 
signal attacking
signal hit 
@export var end_patrol_position: Marker3D
@export var attack_damage:int = 10
var raycasts 
var animation_player
var begin_patrol_position: Vector3
var current_target: Vector3
var state:RatState
var can_attack: bool = true
@export var npc_type:int
@onready var player = get_parent().get_parent().get_node("Player") 
@onready var neighbors =[]
@onready  var terrain:Terrain3D = get_parent().get_parent().get_node("Terrain3D")
@export var node_mesh:Node3D


func revive():
	$EntityHealthHandler.reset_health()




func _ready():
	begin_patrol_position = global_position
	state = PatrolRatState.new(self)
	$EntityHealthHandler.entity_died.connect(_on_death)

func update_neighbors(new_neighbors):
	neighbors = new_neighbors

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
	var total_force = (seek_force * 2.0) + (separation_force * 2.0) + (alignment_force * 1.0) + (avoidance_force * 1.5)
	velocity.x = lerp(velocity.x, total_force.x, 0.05)
	velocity.z = lerp(velocity.z, total_force.z, 0.05)
	var look_pos = Vector3(current_target.x, global_position.y, current_target.z)
	node_mesh.look_at(look_pos, Vector3.UP)
	node_mesh.rotate_y(PI)

func player_entered_range(body_rid, body, body_shape_index, local_shape_index):
	state.try_chase_player(body_rid, body, body_shape_index, local_shape_index)
	alert_neighbors(body_rid, body, body_shape_index, local_shape_index)

func _on_player_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	player_entered_range(body_rid, body, body_shape_index, local_shape_index)

func alert_neighbors(body_rid, body, body_shape_index, local_shape_index):
	for neighbor in neighbors:
		neighbor.state.try_chase_player(body_rid, body, body_shape_index, local_shape_index)


func start_in_leader_status():
	state = PatrolRatState.new(self)
	current_target = end_patrol_position.global_position

func _on_cooldown_timer_timeout():
	state.try_restart_attack()

func restart_attack():
	can_attack = true
	state = ChaseRatState.new(self)

func take_damage(damage):
	hit.emit()
	$EntityHealthHandler.take_damage(self,damage)

func get_stunned():
	state = StunnedRatState.new(self,state)
	$stunned_cooldown.start()
	animation_player.play("Stunned")

func _on_death(a,b):
	state=DeadRatState.new(self)
	#entity_died.emit()
	velocity = Vector3.ZERO

func _on_animation_player_death_animation_finished():
	killed.emit(self)

func _on_stunned_cooldown_timeout():
	state=state.get_previous_state()

func move():
	if (player.global_position - global_position).length() > attack_radius:
		global_position += velocity
	else:
		move_and_slide()
	global_position.y = terrain.data.get_height(global_position)

func start_in_chasing():
	current_target = player.global_position
	state = ChaseRatState.new(self)
