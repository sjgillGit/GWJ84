extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_indication: Node3D = $interact_indication
@onready var lock_clock: AudioStreamPlayer = $lock_clock
@onready var control: Panel = $reward_choose/Control
@onready var reward_choose: CanvasLayer = $reward_choose
@onready var woosh: AudioStreamPlayer = $woosh

func _on_lockpicable_win() -> void:
	animation_player.play("opening")
	lock_clock.play()
	control.scale = Vector2(0.01,0.01)
	var upgrade_list = [["GAS RANGE UP","+20 range","normal","gas"],["HEAVY DAMAGE UP","shot speed down","curse","turret"],["SPRINT SPEED UP","doubles sprint speed","normal","player"]]
	for n in 3:
		control.choose_separator.get_child(n).button_set(n,upgrade_list[n-1][0],upgrade_list[n-1][1],upgrade_list[n-1][2],upgrade_list[n-1][3])
	reward_choose.visible = true
	var tween = get_tree().create_tween().set_parallel(true)
	woosh.play()
	tween.tween_property(control,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
func _ready() -> void:
	interact_indication.hide_ind()
