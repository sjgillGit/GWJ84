extends Panel
@onready var button_show: Panel = $Container/HBoxContainer/column2/hotkeyhelp/button_show
@onready var hotkeyhelpcheck: CheckBox = $Container/HBoxContainer/column2/hotkeyhelp/hotkeyhelpcheck
@export var hide_help: bool = false
@onready var sensitive_value: Label = $Container/HBoxContainer/column2/sensitive_value
@onready var sensitive_slide: HSlider = $Container/HBoxContainer/column2/sensitive_slide

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("HideKeyIndicators"):
		hotkeyhelpcheck.button_pressed = hide_help
		button_show.button_clicked()
		#hide_help = !toggled_on
		if hide_help == true: button_show.modulate = Color(1,1,1,0)
		else: button_show.modulate = Color(1,1,1,1)


func _on_hotkeyhelpcheck_toggled(toggled_on: bool) -> void:
	hide_help = !toggled_on
	if hide_help == true: button_show.modulate = Color(1,1,1,0)
	else: button_show.modulate = Color(1,1,1,1)

func _process(delta: float) -> void:
	sensitive_value.text = str(sensitive_slide.value)


func _on_close_button_pressed() -> void:
	self.visible = false
