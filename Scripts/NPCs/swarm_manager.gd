extends Node3D
var spatial_hash:SpatialHash 
var npc_list:Array = []
#mouse,rat,beaver,bear
@export var mice:PackedScene
@export var rat:PackedScene
@export var bear:PackedScene
@export var beaver:PackedScene
@onready var player = get_parent().get_node("Player")
#var unit_ratios = [0.5,0.3,0.05,0.15]
var unit_ratios = [0,0,1,0]
var mice_pool = []
var rat_pool = []
var beaver_pool = []
var bear_pool = []
var difficulty_level=0
const MAX_ENEMIES = 126
const BASE_SPAWN_COUNT= 10
var current_enemies = BASE_SPAWN_COUNT
var CURRENT_STAT_MULT = 1.0
func init_npc(npc):
	npc_list.append(npc)
	npc.killed.connect(_on_npc_killed)
# Called when the node enters the scene tree for the first time.
func _ready():
	spatial_hash = SpatialHash.new(64)
	for i in range(get_child_count()):
		init_npc(get_child(i))
	var mice_cap = unit_ratios[0]*MAX_ENEMIES
	var rat_cap  = mice_cap + unit_ratios[1]*MAX_ENEMIES
	var beaver_cap = rat_cap + unit_ratios[2]*MAX_ENEMIES
	var bear_cap =  unit_ratios[3]*MAX_ENEMIES
	var npc
	for  i in range(0,mice_cap):
		npc = mice.instantiate()
		_add_to_pool(npc,mice_pool)
	for  i in range(0,rat_cap):
		npc = rat.instantiate()
		_add_to_pool(npc,rat_pool)
	for i in range(0,beaver_cap):
		npc = beaver.instantiate()
		_add_to_pool(npc,beaver_pool)
	for i in range(0,bear_cap):
		npc = bear.instantiate()
		_add_to_pool(npc,bear_pool)

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

func _add_to_pool(npc:Node3D, pool:Array):
	add_child(npc)
	npc.global_position = Vector3(-100, -100, -100) # hidden
	npc.visible = false
	pool.append(npc)
	npc.killed.connect(_on_npc_killed)
	if npc is Beaver:
		init_beaver(npc)
	else:
		npc.start_in_chasing()

# -------------------
# ENEMY MANAGEMENT
# -------------------

func add_npc(position:Vector3):
	# pick type based on ratios
	var rnd = randf()
	var npc
	if rnd < unit_ratios[0]:
		npc = _fetch_from_pool(mice_pool)
	elif rnd < unit_ratios[0] + unit_ratios[1]:
		npc = _fetch_from_pool(rat_pool)
	elif rnd < unit_ratios[0] + unit_ratios[1] + unit_ratios[2]:
		npc = _fetch_from_pool(beaver_pool)
	else:
		npc = _fetch_from_pool(bear_pool)

	if npc == null:
		return # pool empty

	npc.global_position = position
	npc.visible = true
	npc.revive()
	npc_list.append(npc)
	if npc is Beaver:
		init_beaver(npc)

func init_beaver(npc):
	if get_parent().get_node("turrets").get_child_count() == 0:
		npc.end_patrol_position = player
		npc.start_in_leader_status()
	else:
		npc.turret = get_parent().get_node("turrets").get_child(0)
		npc.start_in_chasing()

func _fetch_from_pool(pool:Array) -> Node3D:
	if pool.size() == 0:
		return null
	return pool.pop_back()


func _on_npc_killed(dead_npc:Npc):
	# remove from active list
	npc_list.erase(dead_npc)

	# send back to pool by type
	dead_npc.visible = false
	dead_npc.global_position = Vector3(-100, -100, -100)
	
	if dead_npc.npc_type ==0:
			mice_pool.append(dead_npc)
	if dead_npc.npc_type == 1:
			rat_pool.append(dead_npc)
	if dead_npc.npc_type==2:
			beaver_pool.append(dead_npc)
	if dead_npc.npc_type==3:
			bear_pool.append(dead_npc)
			

func increase_difficulty():
	current_enemies = max(current_enemies+20,MAX_ENEMIES) 

func spawn_enemies(posiiton):
	for i in range(0,current_enemies):
		add_npc(Vector3.ZERO)


func _on_timer_timeout():
	spawn_enemies(Vector3.ZERO)
