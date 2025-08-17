extends Panel
@onready var mission_time: float = GlobalSettings.time
@onready var turrets_number: float = GlobalSettings.towers_deployed
@onready var enemies_number: float = GlobalSettings.enemies_killed
@onready var chests_number: float = GlobalSettings.chests_opened
@onready var banks_number: float = GlobalSettings.banks_robbed

@onready var time_lbl: Label = $MarginContainer/VBoxContainer/time/Label2
@onready var turrets_lbl: Label = $MarginContainer/VBoxContainer/towers_placed/Label2
@onready var enemies_lbl: Label = $MarginContainer/VBoxContainer/enemies_killed/Label2
@onready var banks_lbl: Label = $MarginContainer/VBoxContainer/banks_robbed/Label2
@onready var chests_lbl: Label = $MarginContainer/VBoxContainer/chest_opened/Label2

@onready var time_seconds: int = fmod(mission_time,60)
@onready var time_minutes: int = mission_time/60
@export var couting_up:bool
@export var enemies_count:bool
@export var turrets_count:bool
@export var chests_count:bool
@export var banks_count:bool

@onready var chests_temp: float = 0
@onready var banks_temp: float = 0
@onready var enem_temp: float = 0
@onready var turret_temp: float = 0
@onready var timer: Timer = $Timer
@onready var time: HBoxContainer = $MarginContainer/VBoxContainer/time
@onready var banks_robbed: HBoxContainer = $MarginContainer/VBoxContainer/banks_robbed
@onready var chest_opened: HBoxContainer = $MarginContainer/VBoxContainer/chest_opened
@onready var towers_placed: HBoxContainer = $MarginContainer/VBoxContainer/towers_placed
@onready var enemies_killed: HBoxContainer = $MarginContainer/VBoxContainer/enemies_killed
@onready var pip: AudioStreamPlayer = $pip
var sec_temp: float = 0
var min_temp: float = 0
var skiped: bool = false
@onready var tween
func _ready() -> void:
	self.position.y = (get_viewport().get_visible_rect().size.y - self.size.y) / 2
	timer.start()
	await timer.timeout
	if skiped == false:
		tween = get_tree().create_tween()
		tween.tween_property(time,"modulate",Color(1,1,1,1),0.5)
		couting_up = true
	await timer.timeout
	tween = get_tree().create_tween()
	tween.tween_property(banks_robbed,"modulate",Color(1,1,1,1),0.5)
	turrets_count = true
	await timer.timeout
	tween = get_tree().create_tween()
	tween.tween_property(chest_opened,"modulate",Color(1,1,1,1),0.5)
	turrets_count = true
	await timer.timeout
	tween = get_tree().create_tween()
	tween.tween_property(towers_placed,"modulate",Color(1,1,1,1),0.5)
	turrets_count = true
	if skiped == false:
		tween = get_tree().create_tween()
		tween.tween_property(banks_robbed,"modulate",Color(1,1,1,1),0.5)
		banks_count = true
	await timer.timeout
	if skiped == false:
		tween = get_tree().create_tween()
		tween.tween_property(chest_opened,"modulate",Color(1,1,1,1),0.5)
		chests_count = true
	await timer.timeout
	if skiped == false:
		tween = get_tree().create_tween()
		tween.tween_property(towers_placed,"modulate",Color(1,1,1,1),0.5)
		turrets_count = true
	await timer.timeout
	if skiped == false:
		tween = get_tree().create_tween()
		tween.tween_property(enemies_killed,"modulate",Color(1,1,1,1),0.5)
		enemies_count = true
			

func _process(delta: float) -> void:
	if couting_up: time_count(delta)
	if enemies_number != enem_temp && enemies_count: 
		enem_temp = count_up(delta,enem_temp,enemies_number,enemies_lbl,enemies_count)
	if turret_temp != turrets_number && turrets_count: 
		turret_temp = count_up(delta,turret_temp,turrets_number,turrets_lbl,turrets_count)
		
	if chests_temp != chests_number && chests_count: 
		chests_temp = count_up(delta,chests_temp,chests_number,chests_lbl,chests_count)
	if banks_temp != banks_number && banks_count: 
		banks_temp = count_up(delta,banks_temp,banks_number,banks_lbl,banks_count)
func time_count(delta):
	pip.play()
	sec_temp = min(sec_temp+delta*(time_seconds/3),time_seconds)
	min_temp = min(min_temp+delta*(time_minutes/3),time_minutes)
	time_lbl.text = "%02d:%02d" % [min_temp,sec_temp]
	if sec_temp == time_seconds && min_temp == time_minutes:
		couting_up = false
		time_count_finished(time_lbl)
		
func count_up(delta,temp,_final,text_box,_iffer):
	pip.play()
	text_box.text = str(int(temp))
	temp = min(temp+delta*(_final/3),_final)
	if temp == _final:
		_iffer = false
		time_count_finished(text_box)
	return temp
	
func time_count_finished(lbl):
	lbl.pivot_offset = Vector2(140,lbl.size.y/2)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(lbl,"scale",Vector2(1.4,1.4),1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
func skip():
	skiped = true
	tween.kill()
	enem_temp = enemies_number
	enemies_lbl.text = str(int(enem_temp))
	enemies_killed.modulate = Color(1,1,1,1)
	turret_temp = turrets_number
	turrets_lbl.text = str(int(turret_temp))
	towers_placed.modulate = Color(1,1,1,1)
	chests_temp = chests_number
	chests_lbl.text = str(int(chests_temp))
	chest_opened.modulate = Color(1,1,1,1)
	banks_temp = banks_number
	banks_lbl.text = str(int(banks_temp))
	banks_robbed.modulate = Color(1,1,1,1)
	min_temp = time_minutes
	sec_temp = time_seconds
	time_lbl.text = "%02d:%02d" % [min_temp,sec_temp]
	time_lbl.modulate = Color(1,1,1,1)
	
func _on_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/test_scene.tscn")

func _on_mainmenu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/title.tscn")
