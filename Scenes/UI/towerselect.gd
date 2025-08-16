extends Control
@onready var cooldown_lbl: Label = $TextureButton/cooldownparent/cooldown
@onready var timer: Timer = $Timer
@onready var cooldownparent: Control = $TextureButton/cooldownparent
@export var action_icon: Texture2D
@onready var texture_rect: TextureRect = $TextureButton/TextureRect
@onready var tower
var counting: bool
func fill_button(_tower,_icon):
	action_icon = _icon
	texture_rect.texture = action_icon

func activate_timer(_cooldown):
	timer.wait_time = _cooldown
	timer.start()
	cooldownparent.visible = true
	counting = true
	
func update_timer(time):
	cooldown_lbl.text = time
	
func _process(delta: float) -> void:
	if counting: 
		var time_amount = str(snapped(timer.time_left,0.1))
		update_timer(time_amount)

func _on_timer_timeout() -> void:
	cooldownparent.visible = false
	counting = false
