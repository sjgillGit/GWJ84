extends Control
@onready var hp_bar: TextureProgressBar = $hp_bar
@onready var stam_bar: TextureProgressBar = $stam_bar
@onready var sprint: bool = false
@onready var button_show: Panel = $button_show

@export var stam_recuperation: float = 1
@export var stam_usage: float = 0.5
@export var stam_recuperation_breaker: float = stam_recuperation * 1.5

func change_hp(value:float):
	change_value(value,hp_bar)
func add_max_hp(value:float):
	add_max_value(value,hp_bar)
func add_max_stam(value:float):
	add_max_value(value,stam_bar)
	
func add_max_value(value:float,bar:TextureProgressBar):
	bar.max_value += value
	bar.value += value
	bar.custom_minimum_size.x += value/10

func change_value(value:float,bar:TextureProgressBar):
	var tween = get_tree().create_tween()
	tween.tween_property(bar,"value",bar.value+value,abs(value)/bar.max_value)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shift") && sprint == false:
		var move_tween = get_tree().create_tween()
		move_tween.tween_property(button_show,"scale",Vector2(1.1,1.1),0.05)
		sprint = true
	elif event.is_action_released("Shift") && sprint == true:
		var move_tween = get_tree().create_tween()
		move_tween.tween_property(button_show,"scale",Vector2(1,1),0.1)
		stam_recuperation_breaker = stam_recuperation * 1.5
		sprint = false

func _process(delta: float) -> void:
	if sprint == false && stam_bar.value != stam_bar.max_value: 
		var stam_tween = get_tree().create_tween()
		stam_tween.tween_property(stam_bar,"value",stam_bar.value+(max(0,stam_recuperation-stam_recuperation_breaker)),delta)
		stam_recuperation_breaker *= 0.995
	elif sprint == true: 
		var stam_tween = get_tree().create_tween()
		stam_tween.tween_property(stam_bar,"value",stam_bar.value-stam_usage,delta)


func _on_hp_bar_value_changed(value: float) -> void:
	if value == 0:
		pass #death

func _on_stam_bar_value_changed(value: float) -> void:
	if value == 0:
		var move_tween = get_tree().create_tween()
		move_tween.tween_property(button_show,"scale",Vector2(1,1),0.1)
		stam_recuperation_breaker = stam_recuperation * 1.5
		sprint = false
