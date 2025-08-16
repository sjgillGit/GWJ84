extends RatState
class_name ChaseRatState
func on_physics_process(delta):
	rat.chase_behaviour(delta)
	pass
