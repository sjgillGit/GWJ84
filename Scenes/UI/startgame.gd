extends Control

func _ready() -> void:
	GlobalSettings.multiplier = get_viewport().get_visible_rect().size / Vector2(1920,1080)
	self.scale = Vector2(1,1) * GlobalSettings.multiplier
