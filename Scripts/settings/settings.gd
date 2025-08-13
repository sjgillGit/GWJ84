extends Panel
@onready var button_show: Panel = $Container/HBoxContainer/column2/hotkeyhelp/button_show
@onready var hotkeyhelpcheck: CheckBox = $Container/HBoxContainer/column2/hotkeyhelp/hotkeyhelpcheck
@export var hide_help: bool = false
@onready var sensitive_value: Label = $Container/HBoxContainer/column2/sensitive_value
@onready var sensitive_slide: HSlider = $Container/HBoxContainer/column2/sensitive_slide
@onready var click: AudioStreamPlayer = $click
@onready var roll: AudioStreamPlayer = $roll

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("HideKeyIndicators"):
		click.play()
		hotkeyhelpcheck.button_pressed = hide_help
		button_show.button_clicked()
		#hide_help = !toggled_on
		if hide_help == true: button_show.modulate = Color(1,1,1,0)
		else: button_show.modulate = Color(1,1,1,1)


func _on_hotkeyhelpcheck_toggled(toggled_on: bool) -> void:
	click.play()
	hide_help = !toggled_on
	if hide_help == true: button_show.modulate = Color(1,1,1,0)
	else: button_show.modulate = Color(1,1,1,1)

func _process(delta: float) -> void:
	sensitive_value.text = str(sensitive_slide.value)


func _on_close_button_pressed() -> void:
	click.play()
	self.visible = false

func _on_master_slide_value_changed(value: float) -> void:
	roll.play()
	AudioServer.set_bus_volume_linear(0,value)
	AudioServer.set_bus_mute(0,value < 0.01)
func _on_music_slide_value_changed(value: float) -> void:
	roll.play()
	AudioServer.set_bus_volume_linear(2,value)
	AudioServer.set_bus_mute(2,value < 0.01)
func _on_sfx_slide_value_changed(value: float) -> void:
	roll.play()
	AudioServer.set_bus_volume_linear(1,value)
	AudioServer.set_bus_mute(1,value < 0.01)
func _on_sfx_slide_drag_ended(value_changed: bool) -> void:
	pass
func _on_music_slide_drag_ended(value_changed: bool) -> void:
	pass
func _on_master_slide_drag_ended(value_changed: bool) -> void:
	pass


func _on_sensitive_slide_value_changed(value: float) -> void:
	roll.play()
