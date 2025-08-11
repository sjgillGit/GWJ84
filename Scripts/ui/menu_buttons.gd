extends VBoxContainer
@onready var settings: Panel = $"../settings"


func _on_settings_pressed() -> void:
	settings.visible = ! settings.visible


func _on_startgame_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/test_scene.tscn")
