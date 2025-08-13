extends Control
@onready var input_name_lbl: Label = $button_show/input_name_lbl

func indication_fill(button_visual:String):
	input_name_lbl.text = button_visual
