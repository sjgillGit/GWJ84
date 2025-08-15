extends AnimationPlayer
signal death_animation_finished
@onready var player = get_parent().get_parent()
@onready var ent_handler = get_parent().get_parent().get_node("EntityHealthHandler")


func _ready():
	player =  get_parent().get_parent()
	player.patrolling.connect(_on_rat_patrolling)
	player.chasing.connect(_on_rat_chasing)
	player.attacking.connect(_on_rat_attacking)
	ent_handler.entity_died.connect(_on_entity_health_handler_entity_died)

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
