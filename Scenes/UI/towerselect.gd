extends Control
@onready var cooldown_lbl: Label = $TextureButton/cooldownparent/cooldown
@onready var timer = get_tree().get_root()
@onready var cooldownparent: Control = $TextureButton/cooldownparent
@export var action_icon: Texture2D
@onready var texture_rect: TextureRect = $TextureButton/TextureRect
@onready var tower

func fill_button(_tower,_icon):
	action_icon = _icon
	texture_rect.texture = action_icon

func activate_timer(_cooldown):
	cooldownparent.visible = true
	
func update_timer(time):
	cooldown_lbl.text = time
	
func desactivate_timer():
	cooldownparent.visible = false
