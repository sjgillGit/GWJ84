extends Control
@export var cooldown: float
@export var input_name: StringName
@onready var timer: Timer = $Timer
@onready var cooldownparent: Control = $TextureButton/cooldownparent
@onready var cooldown_lbl: Label = $TextureButton/cooldownparent/cooldown
@onready var counting: bool = false
@onready var input_name_lbl: Label = $button_show/input_name_lbl
@onready var button_show: Panel = $button_show
@onready var button_show_2: Panel = $button_show2

func _ready() -> void:
	fill_button(cooldown,input_name)


func fill_button(_cooldown:float,_inputed:StringName):
	cooldown = _cooldown
	timer.wait_time = cooldown
	input_name = _inputed
	match input_name:
		"PerformAction": input_name_lbl.text = "LMB"
		_: input_name_lbl.text = input_name
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(input_name):
		button_show.button_clicked()
	if event.is_action_pressed("RMB"):
		button_show_2.button_clicked()
	
func skill_activate():
	counting = true
	timer.start()
	cooldownparent.visible = true

func _on_timer_timeout() -> void:
	counting = false
	cooldownparent.visible = false

func _process(_delta: float) -> void:
	if counting: cooldown_lbl.text = str(snapped(timer.time_left,0.1))
