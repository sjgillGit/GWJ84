extends Node3D
@onready var label_2: Label3D = $Label2
@onready var button_show: Sprite3D = $button_show

func show_ind():
	label_2.modulate = Color(1,1,1,1)
	label_2.outline_modulate = Color(1,1,1,1)
	button_show.modulate = Color(1,1,1,1)

func hide_ind():
	label_2.modulate = Color(1,1,1,0)
	label_2.outline_modulate = Color(1,1,1,0)
	button_show.modulate = Color(1,1,1,0)
