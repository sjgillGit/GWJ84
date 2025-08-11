extends RatState
class_name PatrolRatState
func on_physics_process(delta):
	rat.patrol_behaviour(delta)
	pass

func on_navigation_agent_3d_navigation_finished():
	rat.flip_patrol_target()
