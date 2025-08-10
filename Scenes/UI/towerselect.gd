extends Control
@export var cooldown: float
@export var counting: bool
@onready var cooldown_lbl: Label = $TextureButton/cooldownparent/cooldown
@onready var timer = get_tree().get_root()
@onready var cooldownparent: Control = $TextureButton/cooldownparent

@onready var tower

func fill_button(_tower):
	pass

func activate_timer(_cooldown):
	counting = true
	cooldown = _cooldown
	cooldownparent.visible = true
	
func _process(_delta: float) -> void:
	cooldown -= _delta
	if counting: cooldown_lbl.text = str(snapped(cooldown,0.1))
	if cooldown <= 0.0:
		counting = false
		cooldownparent.visible = false
