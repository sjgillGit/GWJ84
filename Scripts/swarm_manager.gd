extends Node3D
var spatial_hash:SpatialHash 
var rat_list:Array = []
var leader 
# Called when the node enters the scene tree for the first time.
func _ready():
	var leader_list = []
	spatial_hash = SpatialHash.new(64)
	for i in range(get_child_count()):
		var rat = get_child(i)
		rat_list.append(rat)
		rat.update_neighbors(get_neighbors(5.0, rat))
		rat.start_in_leader_status()
		leader_list.append(rat)


func get_neighbors(radius,rat):
	var neighbors = []
	for neighbor_rat in rat_list:
		if(rat.global_position - neighbor_rat.global_position).length() <= radius and neighbor_rat !=  rat:
			neighbors.append(neighbor_rat)
	return neighbors
# Called every frame. 'delta' is the elapsed time since the previous frame.
var count =0 
var max_count = 4
func _physics_process(delta):
	count +=1
	spatial_hash.clear()
	for rat in rat_list:
		spatial_hash.insert(rat)
	for rat in rat_list:
		if count==max_count:
			var neighbors = spatial_hash.query(rat.global_position,5)
			rat.update_neighbors(neighbors)
			rat.state.on_physics_process(delta)
		else:
			rat.move_and_slide()
			
	if count==max_count:
			count=0

func add_rat(rat,position):
	add_child(rat)
	rat.global_position = position
	rat_list.append(rat)


func _on_rat_killed(dead_rat):
	rat_list.erase(dead_rat)
