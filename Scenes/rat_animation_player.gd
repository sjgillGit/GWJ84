extends AnimationPlayer


func _on_rat_killed():
	play("Attack")


func _on_rat_patrolling():
	play("Walk")


func _on_rat_chasing():
	play("Run")


func _on_rat_attacking():
	play("Attack")
	play("Getup")
