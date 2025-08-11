extends Node3D
@export var swarm_manager:Node3D 
@onready var rat_scene = preload("res://Scenes/rat.tscn")
@export var patrol_end:Marker3D 

func _on_timer_timeout():
	var leader_rat = rat_scene.instantiate()
	leader_rat.start_in_leader_status()
	leader_rat.end_patrol_position = patrol_end
	swarm_manager.add_rat(leader_rat,global_position + Vector3(3,2,3))
	for i in range(10):
		var ith_rat = rat_scene.instantiate()
		ith_rat.end_patrol_position = patrol_end
		ith_rat.start_in_swarm_status(leader_rat)
		swarm_manager.add_rat(ith_rat,global_position + Vector3(5+i*2,2,5+i*2))
