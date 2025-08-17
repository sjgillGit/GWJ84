extends Npc
class_name Rat
func _ready():
	super()
	raycasts = [
	node_mesh.get_node("raycasts/forward_raycast"),
	node_mesh.get_node("raycasts/positive_45_raycast"),
	node_mesh.get_node("raycasts/minus_45_raycast")
	]
	animation_player = node_mesh.get_node("AnimationPlayer")
	animation_player.death_animation_finished.connect(_on_animation_player_death_animation_finished)


func flip_patrol_target():
	if current_target==begin_patrol_position:
		current_target = end_patrol_position.global_position
	else:
		current_target = begin_patrol_position

func patrol_behaviour(delta):
	patrolling.emit()
	boid_calculation((current_target - global_position).normalized() * speed,delta)
	if abs(current_target.x + current_target.z - global_position.x - global_position.z) < 1:
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
		$attacking_sounds.play()
		attacking.emit()
		player.take_damage(attack_damage)
		can_attack = false

func chase_player(body_rid, body, body_shape_index, local_shape_index):
	state = ChaseRatState.new(self)
	current_target = body.global_position
	player = body
	velocity = Vector3.ZERO
