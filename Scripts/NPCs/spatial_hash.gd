class_name SpatialHash
var cell_size: float
var buckets :Dictionary= {}

func _init(cell_size: float):
	self.cell_size = cell_size

func _cell_coords(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos.x / cell_size), floor(pos.y / cell_size))

func clear():
	buckets.clear()

func insert(obj):
	var pos: Vector2 = Vector2i(obj.global_position.x,obj.global_position.z)
	var cell = _cell_coords(pos)
	if not buckets.has(cell):
		buckets[cell] = []
	buckets[cell].append(obj)

func query(position:Vector3,radius:int) -> Array:
	var pos: Vector2 = Vector2i(position.x,position.z)
	var cell = _cell_coords(pos)
	var results := []
	for dx in range(-radius,radius):
		for dy in range(-radius,radius):
			if dx==0 and dy==0: continue
			var neighbor_cell = cell + Vector2i(dx, dy)
			if buckets.has(neighbor_cell):
				results.append_array(buckets[neighbor_cell])
	return results
