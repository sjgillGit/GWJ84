extends Control
@onready var temp: HBoxContainer = $SubViewportContainer/SubViewport/temp
@onready var towerlist: HBoxContainer = $SubViewportContainer/SubViewport/towerscroll/towerlist
@onready var towerscroll: ScrollContainer = $SubViewportContainer/SubViewport/towerscroll
@export var inputed: StringName
@export var scroll_x := 46
@export var cooldown: float
@onready var counting: bool
@onready var timer: Timer = $Timer
@onready var fulltowerlist: HBoxContainer = $SubViewportContainer/SubViewport/fulltowerlist
@onready var chosen_tower
@onready var scroll: AudioStreamPlayer = $scroll
const TOWERSELECT = preload("res://Scenes/UI/towerselect.tscn")

func scroll_up():
		scroll.play()
		for n in towerlist.get_children().size() -1:
			towerlist.get_child(0).reparent(temp)
		for n in temp.get_children():
			n.reparent(towerlist)
		towerscroll.scroll_horizontal = 92
func scroll_down():
		scroll.play()
		towerlist.get_child(0).reparent(temp)
		temp.get_child(0).reparent(towerlist)
		towerscroll.scroll_horizontal = 0
		
		#chosen_tower = towerlist.get_child(2)
func skill_activate(cooldown):
	timer.wait_time = cooldown
	counting = true
	timer.start()
	towerlist.get_child(2).activate_timer(cooldown)

func _ready() -> void:
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(towerscroll,"scroll_horizontal",46,0.07).set_delay(0.01)
	
	for n in towerlist.get_children():
		n.queue_free()
	var ile: int = 0
	while ile <= 5:
		for n in fulltowerlist.get_children().size():
			var tower = TOWERSELECT.instantiate()
			towerlist.add_child(tower)
			tower.fill_button(fulltowerlist.get_child(n).tower,fulltowerlist.get_child(n).action_icon)
			ile += 1

func _on_timer_timeout() -> void:
	counting = false
	for n in towerlist.get_children():
			n.desactivate_timer()
			
func _process(_delta: float) -> void:
	if counting: 
		var time_amount = str(snapped(timer.time_left,0.1))
		for n in towerlist.get_children():
			n.update_timer(time_amount)
