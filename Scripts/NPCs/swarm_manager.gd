extends Node3D
var spatial_hash:SpatialHash 
var npc_list:Array = []
var leader 
# Called when the node enters the scene tree for the first time.
func _ready():
	var leader_list = []
	spatial_hash = SpatialHash.new(64)
	for i in range(get_child_count()):
		var npc = get_child(i)
		npc_list.append(npc)
		npc.update_neighbors(get_neighbors(5.0, npc))
		npc.start_in_leader_status()
		leader_list.append(npc)


func get_neighbors(radius,npc):
	var neighbors = []
	for neighbor_npc in npc_list:
		if(npc.global_position - neighbor_npc.global_position).length() <= radius and neighbor_npc !=  npc:
			neighbors.append(neighbor_npc)
	return neighbors
# Called every frame. 'delta' is the elapsed time since the previous frame.
var count =0 
var max_count = 14
func _physics_process(delta):
	count +=1
	if count==max_count:
		spatial_hash.clear()
		for npc in npc_list:
			spatial_hash.insert(npc)
	for npc in npc_list:
		if count==max_count:
			var neighbors = spatial_hash.query(npc.global_position,5)
			npc.update_neighbors(neighbors)
			npc.state.on_physics_process(delta)
		else:
			npc.move()
	if count==max_count:
			count=0

func aaa(npc_index,delta):
	var npc:Npc = npc_list[npc_index]
	npc.state.on_physics_process(delta)


func add_npc(npc,position):
	add_child(npc)
	npc.global_position = position
	npc_list.append(npc)


func _on_npc_killed(dead_npc):
	npc_list.erase(dead_npc)
