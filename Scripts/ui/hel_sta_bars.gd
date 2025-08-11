extends Control
@onready var hp_bar: TextureProgressBar = $hp_bar
@onready var stam_bar: TextureProgressBar = $stam_bar
@onready var sprint: bool = false
@onready var button_show: Panel = $button_show
@onready var aptitude: int
@export var stam_recuperation: float = 1
@export var stam_usage: float = 0.5
@export var stam_recuperation_breaker: float = stam_recuperation * 1.5

func change_hp(value:float):
	change_value(value,hp_bar)
	if value < 0:
		aptitude = 100*(abs(value)/hp_bar.max_value)
		print(value,"  ",aptitude)
		self.material.set_shader_parameter("amplitude",aptitude)
func add_max_hp(value:float):
	add_max_value(value,hp_bar)
func add_max_stam(value:float):
	add_max_value(value,stam_bar)
	
func add_max_value(value:float,bar:TextureProgressBar):
	bar.max_value += value
	bar.value += value
	queue_redraw()

func change_value(value:float,bar:TextureProgressBar):
	var speed := 1
	if value > 0 : speed = 2
	var tween = get_tree().create_tween()
	tween.tween_property(bar,"value",bar.value+value,abs(value)/bar.max_value * speed)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Sprint") && sprint == false:
		var move_tween = get_tree().create_tween()
		move_tween.tween_property(button_show,"scale",Vector2(1.1,1.1),0.05)
		sprint = true
	elif event.is_action_released("Sprint") && sprint == true:
		var move_tween = get_tree().create_tween()
		move_tween.tween_property(button_show,"scale",Vector2(1,1),0.1)
		stam_recuperation_breaker = stam_recuperation * 1.5
		sprint = false

func _process(delta: float) -> void:
	if aptitude > 0:
		aptitude = aptitude * 38/40
		self.material.set_shader_parameter("amplitude",aptitude)
	hp_bar.tint_over = Color.RED.lerp(Color.WHITE, hp_bar.value / hp_bar.max_value)
	hp_bar.tint_under = Color(0.419, 0.09, 0.137).lerp(Color(0.23, 0.23, 0.23), hp_bar.value / hp_bar.max_value)
	stam_bar.tint_progress = Color.GRAY.lerp(Color(0.85, 0.632, 0.196), stam_bar.value / stam_bar.max_value)
	
	if sprint == false && stam_bar.value != stam_bar.max_value: 
		var stam_tween = get_tree().create_tween()
		stam_tween.tween_property(stam_bar,"value",stam_bar.value+(max(0,stam_recuperation-stam_recuperation_breaker)),delta)
		stam_recuperation_breaker *= 0.995
	elif sprint == true: 
		var stam_tween = get_tree().create_tween()
		stam_tween.tween_property(stam_bar,"value",stam_bar.value-stam_usage,delta)

func _on_stam_bar_value_changed(value: float) -> void:
	if value == 0:
		var move_tween = get_tree().create_tween()
		move_tween.tween_property(button_show,"scale",Vector2(1,1),0.1)
		stam_recuperation_breaker = stam_recuperation * 1.5
		sprint = false

func _draw() -> void:
	var m_value = hp_bar.max_value
	for n in int(m_value/10):
		var procent = (n*10) / m_value
		var x : float = 80 *sin(deg_to_rad(360*procent)) + 100
		var y : float = 80 *cos(deg_to_rad(360*procent)) + 100
		
		var x_down : float = 70 *sin(deg_to_rad(360*procent)) + 100
		var y_down : float = 70 *cos(deg_to_rad(360*procent)) + 100
		
		draw_line(Vector2(x_down,y_down),Vector2(x,y),Color(1,1,1,1),2)
		
	for n in int(m_value/50):
		var procent = (n*50) / m_value
		var x : float = 90 *sin(deg_to_rad(360*procent)) + 100
		var y : float = 90 *cos(deg_to_rad(360*procent)) + 100
		
		var x_down : float = 70 *sin(deg_to_rad(360*procent)) + 100
		var y_down : float = 70 *cos(deg_to_rad(360*procent)) + 100
		
		draw_line(Vector2(x_down,y_down),Vector2(x,y),Color(1,1,1,1),2)


func _on_button_pressed() -> void:
	change_hp(-(randi() % 150 + 50))


func _on_button_2_pressed() -> void:
	change_hp((randi() % 150 + 50))
