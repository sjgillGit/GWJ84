extends VBoxContainer
@onready var settings: Panel = $"../settings"
@onready var click: AudioStreamPlayer = $"../settings/click"
@onready var hover: AudioStreamPlayer = $"../settings/hover"
@onready var credits: Panel = $"../credits"

func _on_settings_pressed() -> void:
	settings.visible = ! settings.visible
	click.play()

func _on_startgame_pressed() -> void:
	click.play()
	get_tree().change_scene_to_file("res://Scenes/UI/test_scene.tscn")
func _on_quit_pressed() -> void:
	click.play()
	get_tree().quit()
func _on_startgame_mouse_entered() -> void:
	hover.play()

func _on_settings_mouse_entered() -> void:
	hover.play()

func _on_quit_mouse_entered() -> void:
	hover.play()

func _on_credits_pressed() -> void:
	click.play()
	credits.visible = !credits.visible 
	
func _on_credits_mouse_entered() -> void:
	hover.play()
