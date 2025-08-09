extends Control
@export var mission_time: float
@onready var hand: ColorRect = $hand
@onready var progressbar: TextureProgressBar = $progressbar
@onready var watch_positioning = self.position
@onready var move_tween = get_tree().create_tween()
@onready var timer: Timer = $Timer
@onready var back_tween = get_tree().create_tween()
@onready var watch: CanvasGroup = $".."
@onready var button: Panel = $"../Panel"
@onready var odliczanie: bool = false
func _ready() -> void:
	timer_reset()
	timer_start(mission_time)
	
func timer_reset():
	progressbar.visible = true
	odliczanie = true
	move_tween.kill()
	back_tween = get_tree().create_tween()
	back_tween.tween_property(self,"position",watch_positioning,0.2).set_trans(Tween.TRANS_CIRC)
	watch.material.set_shader_parameter("hit_effect",0)
	hand.rotation_degrees = 0
	progressbar.value = 0
	progressbar.self_modulate = Color(1,1,1,0)

func timer_start(_time:float):
	var time_max = _time
	timer.wait_time = time_max
	timer.start()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(hand,"rotation_degrees",360,time_max)
	tween.tween_property(progressbar,"value",360,time_max)
	tween.tween_property(progressbar,"self_modulate",Color(1,1,1,1),time_max)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("watch_open") && odliczanie:
		back_tween.kill()
		move_tween = get_tree().create_tween()
		move_tween.tween_property(button,"scale",Vector2(1.1,1.1),0.05)
		move_tween.tween_property(self,"position",watch_positioning-Vector2(170,0),0.5).set_trans(Tween.TRANS_CIRC)
	elif event.is_action_released("watch_open") && odliczanie:
		move_tween.kill()
		back_tween = get_tree().create_tween()
		back_tween.tween_property(button,"scale",Vector2(1,1),0.1)
		back_tween.tween_property(self,"position",watch_positioning,0.5).set_trans(Tween.TRANS_CIRC)
func button_clicked():
	var tween = get_tree().create_tween()
	
	

func _on_timer_timeout() -> void:
	odliczanie = false
	back_tween.kill()
	move_tween = get_tree().create_tween()
	move_tween.tween_property(self,"position",watch_positioning-Vector2(170,0),0.5).set_trans(Tween.TRANS_CIRC)
	watch.material.set_shader_parameter("hit_effect",0.5)
	for n in 10:
		progressbar.visible = !progressbar.visible
		var timer_2 = get_tree().create_timer(0.5)
		await timer_2.timeout
	timer_reset()
	timer_start(mission_time)
