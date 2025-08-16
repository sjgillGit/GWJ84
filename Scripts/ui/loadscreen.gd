extends Control
@onready var gwj_logo: TextureRect = $gwj_logo
@onready var background: ColorRect = $background
@onready var godot_logo : TextureRect = $godot_logo
@onready var timer: Timer = $Timer

func _ready() -> void:
	GlobalSettings.multiplier = get_viewport().get_visible_rect().size / Vector2(1920,1080)

	#background.scale = GlobalSettings.multiplier
#	godot_logo.scale = GlobalSettings.multiplier
	#gwj_logo.scale = GlobalSettings.multiplier
	gwj_logo.modulate = Color(1,1,1,0)
	godot_logo.modulate = Color(1,1,1,0)
	await timer.timeout
	var tween = get_tree().create_tween()
	tween.tween_property(background,"color",Color(0.042, 0.203, 0.047),6)
	await timer.timeout
	trans(1,gwj_logo)
	await timer.timeout
	await timer.timeout
	trans(0,gwj_logo)
	await timer.timeout
	trans(1,godot_logo)
	await timer.timeout
	await timer.timeout
	trans(0,godot_logo)
	await timer.timeout
	await timer.timeout
	trans(0,self)
	await timer.timeout
	self.queue_free()
func trans(color_a:float,node:Node):
	var tween = get_tree().create_tween()
	tween.tween_property(node,"modulate",Color(1,1,1,color_a),1)

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		trans(0,self)
		await timer.timeout
		self.queue_free()
