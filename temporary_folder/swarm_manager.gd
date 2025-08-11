extends Node3D
var rat_list:Array = []
var leader 
# Called when the node enters the scene tree for the first time.
func _ready():
	for rat in get_children():
		rat_list.append(rat)
		rat.update_neighbors(get_neighbors(5.0,rat))
		rat.start_in_swarm_status(rat_list[0])
	leader = rat_list[0]
	leader.start_in_leader_status()


func get_neighbors(radius,rat):
	var neighbors = []
	for neighbor_rat in rat_list:
		if(rat.global_position - neighbor_rat.global_position).length() <= radius and neighbor_rat !=  rat:
			neighbors.append(neighbor_rat)
	return neighbors
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for rat in rat_list:
		var current_rat_neighbors = get_neighbors(5.0,rat)
		rat.update_neighbors(current_rat_neighbors)
		rat.state.on_physics_process(delta)
