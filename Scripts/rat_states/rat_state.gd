extends Object
class_name RatState
var rat:Rat
func _init(a_rat):
	rat=a_rat
func on_physics_process(delta):
	pass

func on_navigation_agent_3d_navigation_finished():
	pass

func try_chase_player(body_rid, body, body_shape_index, local_shape_index):
	rat.chase_player(body_rid, body, body_shape_index, local_shape_index)

func try_restart_attack():
	rat.restart_attack()
