extends Node3D
@onready var sprite_3d: Sprite3D = $Cylinder/Sprite3D
@onready var spin_speed: int

func set_nail(symbol: String, difficulty):
	var text_string = "res://Assets/ui/symbols/%s.png" % symbol
	sprite_3d.texture = load(text_string)
	spin_speed = difficulty

func _process(delta: float) -> void:
	if spin_speed != 0:
		self.rotation_degrees += Vector3(0,0,(delta*spin_speed))

func light_up():
	sprite_3d.modulate = Color(0.174, 0.58, 0.28)
func unlight():
	sprite_3d.modulate = Color(1,1,1)
func first():
	sprite_3d.modulate = Color(0.827, 0.818, 0.375)
