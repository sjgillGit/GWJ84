extends Node3D
@export var level: int
@onready var robbable: Node3D = $robbable
@onready var interact_indication: Node3D = $interact_indication
@onready var lock_clock: AudioStreamPlayer = $lock_clock
@onready var reward_choose: CanvasLayer = $reward_choose
@onready var woosh: AudioStreamPlayer = $woosh
@onready var door: AudioStreamPlayer = $door
const REWARD_MENU = preload("res://Scenes/UI/reward_menu.tscn")

func _ready() -> void:
	interact_indication.hide_ind()
	robbable.level = level
	robbable.start()
func _on_robbable_win() -> void:
	lock_clock.play()
	door.play()
	var rewards = REWARD_MENU.instantiate()
	var upgrade_list = [["GAME UPDATES RATE UP","We will add updates more frequently","normal","gas"],["COOLNESS UP","+20 to the cool stat","curse","player"],["TURRET SELFAWARENESS UP","Turret has higher chance to see itself in the mirror","normal","turret"]]
	reward_choose.add_child(rewards)
	rewards.scale = Vector2(0.01,0.01)
	for n in 3:
		rewards.choose_separator.get_child(n).button_set(n,upgrade_list[n-1][0],upgrade_list[n-1][1],upgrade_list[n-1][2],upgrade_list[n-1][3])
	reward_choose.visible = true
	var tween = get_tree().create_tween().set_parallel(true)
	woosh.play()
	tween.tween_property(rewards,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
