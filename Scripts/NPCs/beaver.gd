extends Npc
class_name Beaver
var turret
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
	current_target = turret.global_position
	boid_calculation((turret.global_position - global_position).normalized()*speed,delta)
	if (turret.global_position - global_position).length() < attack_radius:
		state = AttackRatState.new(self)

func attack_behaviour(delta):
	if can_attack and (turret.global_position-global_position).length() <= attack_radius:
		velocity = Vector3.ZERO
		$attack_cooldown_timer.start()
		$attacking_sounds.play()
		attacking.emit()
		turret.get_node("EntityHealthHandler").take_damage(turret,attack_damage)
		can_attack = false

func chase_turret(body_rid, body, body_shape_index, local_shape_index):
	state = ChaseRatState.new(self)
	current_target = body.global_position
	player = body
	velocity = Vector3.ZERO
	get_node

func start_in_chasing():
	current_target = turret.global_position
	state = ChaseRatState.new(self)

func chase_player(body_rid, body, body_shape_index, local_shape_index):
	state = ChaseRatState.new(self)
	current_target = body.global_position
	player = body
	velocity = Vector3.ZERO
