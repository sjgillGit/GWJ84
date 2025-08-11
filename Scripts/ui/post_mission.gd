extends Control
@onready var czesc2: Panel = $Control2
@onready var czesc1: Panel = $Control
var czesc2show:= false
func _input(event: InputEvent) -> void:
	if event.is_pressed() && czesc2show == false:
			czesc2show = true
			czesc2.scale = Vector2(0.01,0.01)
			czesc2.visible = true
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(czesc2,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(czesc1,"scale",Vector2(0.01,0.01),1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			
