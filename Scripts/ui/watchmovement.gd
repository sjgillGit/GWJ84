extends Control
@export var mission_time: float
@onready var hand: TextureRect = $hand
@onready var progressbar: TextureProgressBar = $progressbar
@onready var timer: Timer = $Timer
@onready var watch: CanvasGroup = $".."
@onready var odliczanie: bool = false
func _ready() -> void:
	timer_reset()
	timer_start(mission_time)
	resolution_set()
func resolution_set():
	self.position.x = get_viewport().get_visible_rect().size.x - 166
func timer_reset():
	progressbar.visible = true
	odliczanie = true
	watch.material.set_shader_parameter("hit_effect",0)
	hand.rotation_degrees = 0
	progressbar.value = 0
	progressbar.tint_progress = Color(1,1,1,0)

func timer_start(_time:float):
	var time_max = _time
	timer.wait_time = time_max
	timer.start()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(progressbar,"tint_progress",Color(1,1,1,1),time_max)
	tween.tween_property(hand,"rotation_degrees",360,time_max)
	tween.tween_property(progressbar,"value",360,time_max)
	

func _on_timer_timeout() -> void:
	odliczanie = false
	watch.material.set_shader_parameter("hit_effect",0.5)
	for n in 10:
		progressbar.visible = !progressbar.visible
		var timer_2 = get_tree().create_timer(0.5)
		await timer_2.timeout
	timer_reset()
	timer_start(mission_time)
