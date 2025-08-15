extends AnimationPlayer
signal death_animation_finished
func _on_rat_patrolling():
	play("Walk")


func _on_rat_chasing():
	play("Run")


func _on_rat_attacking():
	play("Attack")
	queue("Getup")


func _on_animation_finished(anim_name):
	if anim_name=="Stunned":
		death_animation_finished.emit()


func _on_entity_health_handler_entity_died(entity, handler):
	play_section("Stunned",0.0,5.0)
