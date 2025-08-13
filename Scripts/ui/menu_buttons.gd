extends VBoxContainer
@onready var settings: Panel = $"../settings"
@onready var click: AudioStreamPlayer = $"../settings/click"


func _on_settings_pressed() -> void:
	settings.visible = ! settings.visible
	click.play()


func _on_startgame_pressed() -> void:
	click.play()
	get_tree().change_scene_to_file("res://Scenes/UI/test_scene.tscn")


func _on_quit_pressed() -> void:
	click.play()
