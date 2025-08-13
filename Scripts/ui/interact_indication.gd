extends Node3D
@onready var label_2: Label3D = $Label2
@onready var button_show: Sprite3D = $button_show

func show_ind():
	label_2.visible = true
	button_show.visible = true

func hide_ind():
	label_2.visible = false
	button_show.visible = false
