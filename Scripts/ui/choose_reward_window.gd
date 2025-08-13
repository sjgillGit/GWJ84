extends Button
@onready var main: Label = $MarginContainer/main
@onready var sub: Label = $MarginContainer/sub
@onready var sub_viewport: SubViewport = $MarginContainer/SubViewportContainer/SubViewport
@onready var turret: StaticBody3D = $MarginContainer/SubViewportContainer/SubViewport/Node3D/turret
@onready var gas: MeshInstance3D = $MarginContainer/SubViewportContainer/SubViewport/Node3D/gas
@onready var goblin: Node3D = $MarginContainer/SubViewportContainer/SubViewport/Node3D/goblin
@onready var node_3d: Node3D = $MarginContainer/SubViewportContainer/SubViewport/Node3D

@onready var control: Panel = $"../../../.."
var object
var number:int
func button_set(_number:int,main_text,sub_text,type,_object):
	object = _object
	number = _number
	node_3d.position.x -= 21 * number
	node_3d.position.z -= 10 * number
	main.text = main_text
	sub.text = sub_text
	match _object:
		"turret":
			turret.visible = true
		"gas":
			gas.visible = true
		"player":
			goblin.visible = true
	if type == "curse":
		self.theme = load("res://Assets/ui/menu_curse.tres")
func _on_pressed() -> void:
	control.reward_chosen(number,object)
