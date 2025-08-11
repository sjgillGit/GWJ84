extends Panel


func button_clicked():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"scale",Vector2(1.1,1.1),0.05)
	tween.tween_property(self,"scale",Vector2(1,1),0.1)
