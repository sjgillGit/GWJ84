extends Control
@onready var woosh: AudioStreamPlayer = $woosh
const DEATH_PANEL = preload("res://Scenes/UI/death_panel.tscn")
const MISSION_COMPLETED = preload("res://Scenes/UI/mission_completed.tscn")
@onready var victory: AudioStreamPlayer = $victory
@onready var goblin: Node3D = $SubViewportContainer/SubViewport/Goblin
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var spawn: Control = $spawn
var skiped:= false
var panel
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	sub_viewport_container.scale = GlobalSettings.multiplier
	post_mission(false)

func post_mission(iswin:bool):
	if iswin:
		victory.play()
		panel = MISSION_COMPLETED.instantiate()
		spawn.add_child(panel)
		goblin.win()
	else:
		victory.play()
		panel = DEATH_PANEL.instantiate()
		spawn.add_child(panel)
		goblin.death()
func _input(event: InputEvent) -> void:
	if event.is_pressed() && skiped == false:
			skiped = true
			panel.skip()
	
