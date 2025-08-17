extends Control
@onready var woosh: AudioStreamPlayer = $woosh
const DEATH_PANEL = preload("res://Scenes/UI/death_panel.tscn")
const MISSION_COMPLETED = preload("res://Scenes/UI/mission_completed.tscn")
@onready var victory: AudioStreamPlayer = $victory
@onready var goblin: Node3D = $SubViewportContainer/SubViewport/Camera3D/Goblin
var skiped:= false
var panel
func _ready() -> void:
	post_mission(false)

func post_mission(iswin:bool):
	if iswin:
		victory.play()
		panel = MISSION_COMPLETED.instantiate()
		self.add_child(panel)
		goblin.win()
	else:
		panel = DEATH_PANEL.instantiate()
		self.add_child(panel)
		goblin.death()
func _input(event: InputEvent) -> void:
	if event.is_pressed() && skiped == false:
			skiped = true
			panel.skip()
	
