extends RatState
class_name StunnedRatState
var previous_state:RatState
func _init(a_rat,state):
	super._init(a_rat)
	previous_state = state
func get_previous_state():
	return previous_state

func try_chase_player(body_rid, body, body_shape_index, local_shape_index):
	return
	
func try_restart_attack():
	return 
