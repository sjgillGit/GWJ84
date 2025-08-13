class_name SpatialHash
var cell_size: float
var buckets :Dictionary= {}

func _init(cell_size: float):
	self.cell_size = cell_size

func _cell_coords(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos.x / cell_size), floor(pos.y / cell_size))

func clear():
	buckets.clear()

func insert(obj, pos: Vector2):
	var cell = _cell_coords(pos)
	if not buckets.has(cell):
		buckets[cell] = []
	buckets[cell].append(obj)

func query(pos: Vector2) -> Array:
	var cell = _cell_coords(pos)
	var results := []
	for dx in range(-1,2):
		for dy in range(-1,2):
			var neighbor_cell = cell + Vector2i(dx, dy)
			if buckets.has(neighbor_cell):
				results.append_array(buckets[neighbor_cell])
	return results
