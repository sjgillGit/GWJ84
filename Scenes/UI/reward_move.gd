extends SubViewportContainer
@onready var reward = $SubViewport/reward
@onready var sub_viewport_container: SubViewportContainer = $"."
var pozycja_zero: float = 0
@onready var floating:= true
@onready var max_move:= 15.0
func _process(delta: float) -> void:
	reward.rotation_degrees += Vector3(0,delta*10,0)
	if pozycja_zero:
		sub_viewport_container.position.y = sub_viewport_container.position.y+delta*20
		if sub_viewport_container.position.y >= pozycja_zero+max_move:
			pozycja_zero= false
	else:
		sub_viewport_container.position.y = sub_viewport_container.position.y-delta*20
		if sub_viewport_container.position.y <= pozycja_zero-max_move:
			pozycja_zero = true
