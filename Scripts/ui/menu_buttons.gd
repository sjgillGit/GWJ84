extends VBoxContainer
@onready var settings: Panel = $"../settings"


func _on_settings_pressed() -> void:
	settings.visible = ! settings.visible
