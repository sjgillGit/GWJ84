extends Control
@onready var control: Control = $Control

func _ready() -> void:
	control.visible = GlobalSettings.title_logos
	GlobalSettings.title_logos = false
	GlobalSettings.multiplier = get_viewport().get_visible_rect().size / Vector2(1920,1080)
	self.scale = Vector2(1,1) * GlobalSettings.multiplier
