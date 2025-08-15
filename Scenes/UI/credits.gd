extends Panel
@onready var click: AudioStreamPlayer = $click


func _on_close_button_pressed() -> void:
	click.play()
	self.visible = false
