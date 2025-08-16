extends Control
@onready var czesc1: Panel = $Control
@onready var woosh: AudioStreamPlayer = $woosh

var skiped:= false
func _input(event: InputEvent) -> void:
	if event.is_pressed() && skiped == false:
			skiped = true
			czesc1.skip()
	
