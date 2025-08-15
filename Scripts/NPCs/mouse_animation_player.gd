extends AnimationPlayer
signal death_animation_finished
var player

func _ready():
	player =  get_parent().get_parent()
	player.patrolling.connect(_on_rat_patrolling)
	player.chasing.connect(_on_rat_chasing)
	player.attacking.connect(_on_rat_attacking)
	
func _on_rat_patrolling():
	play("skipping")

func _on_rat_chasing():
	play("skipping")

func _on_rat_attacking():
	play("Attack")
	queue("Getup")


func _on_animation_finished(anim_name):
	if anim_name=="Stunned":
		death_animation_finished.emit()


func _on_entity_health_handler_entity_died(entity, handler):
	play_section("Stunned",0.0,5.0)
