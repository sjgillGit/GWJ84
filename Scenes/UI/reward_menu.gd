extends Panel
var smash_count:= 0
@onready var gas: MeshInstance3D = $MarginContainer/VBoxContainer/show_reward/SubViewportContainer/SubViewport/reward/gas
@onready var turret: StaticBody3D = $MarginContainer/VBoxContainer/show_reward/SubViewportContainer/SubViewport/reward/turret
@onready var goblin: Node3D = $MarginContainer/VBoxContainer/show_reward/SubViewportContainer/SubViewport/reward/goblin
@onready var choose_separator: Control = $MarginContainer/VBoxContainer/choose_separator
@onready var show_reward: Control = $MarginContainer/VBoxContainer/show_reward
@onready var smash_1: Label = $MarginContainer/VBoxContainer/separator/smash_1
@onready var separator: Control = $MarginContainer/VBoxContainer/separator
@onready var new_sepatator: Control = $"MarginContainer/VBoxContainer/new sepatator"
@onready var smash_2: Label = $MarginContainer/VBoxContainer/separator/smash_2
@onready var smash_3: Label = $MarginContainer/VBoxContainer/separator/smash_3
@onready var choose: Button = $MarginContainer/VBoxContainer/choose_separator/choose
@onready var choose_2: Button = $MarginContainer/VBoxContainer/choose_separator/choose2
@onready var choose_3: Button = $MarginContainer/VBoxContainer/choose_separator/choose3
@onready var origin_pos: Vector2 = self.position
@onready var gpu_particles_2d: GPUParticles2D = $Label/GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $Label/GPUParticles2D2
@onready var s_smash: AudioStreamPlayer = $Control/smash
@onready var s_smash_2: AudioStreamPlayer = $Control/smash2
@onready var s_smash_3: AudioStreamPlayer = $Control/smash3
@onready var s_smash_4: AudioStreamPlayer = $Control/smash4
@onready var woosh: AudioStreamPlayer = $Control/woosh
var values = [20,-15,-20,25,17,-13]
func smash() -> void:
	match smash_count:
		0:
			s_smash.play()
			smash_me(smash_1,choose)
			var tween = get_tree().create_tween().set_parallel(true)
			#tween.tween_property(self,"position",origin_pos + Vector2(5,15),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self,"scale",Vector2(1.02,1.02),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		1:
			s_smash_2.play()
			smash_me(smash_2,choose_2)
			var tween = get_tree().create_tween().set_parallel(true)
			#tween.tween_property(self,"position",origin_pos + Vector2(13,-3),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self,"scale",Vector2(1.04,1.04),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		2:
			s_smash_3.play()
			smash_me(smash_3,choose_3)
			var tween = get_tree().create_tween().set_parallel(true)
			#tween.tween_property(self,"position",origin_pos + Vector2(-10,7),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self,"scale",Vector2(1.08,1.08),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		4:
			woosh.play()
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(self,"scale",Vector2(0.01,0.01),1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			await tween.finished
			self.queue_free()
	smash_count += 1

func _input(event: InputEvent) -> void:
	if smash_count == 3:
		if event.is_action_pressed("option_1"):
			choose.chosen()
		elif event.is_action_pressed("option_2"):
			choose_2.chosen()
		elif event.is_action_pressed("option_3"):
			choose_3.chosen()
	else:
		if event.is_action_pressed("PerformAction"):
			smash()
func reward_chosen(number_chosen:int,object):
	smash_count += 1
	match object:
		"gas":
			gas.visible = true
		"player":
			goblin.visible = true
		"turret":
			turret.visible = true
	s_smash_4.play()
	choose_separator.pivot_offset = Vector2(230,200)
	show_reward.scale = Vector2(0.01,0.01)
	new_sepatator.pivot_offset = Vector2(230,200)
	show_reward.pivot_offset = Vector2(230,175)
	new_sepatator.scale = Vector2(0.01,0.01)
	new_sepatator.modulate = Color(1,1,1,1)
	show_reward.modulate = Color(1,1,1,1)
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self,"position",origin_pos,0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(choose_separator,"scale",Vector2(0.01,0.01),1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_sepatator,"scale",Vector2(1,1),2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(show_reward,"scale",Vector2(1,1),2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	gpu_particles_2d.emitting = true
	gpu_particles_2d_2.emitting = true
	await tween.finished
	choose_separator.visible = false

func smash_me(label: Label,reward:Button):
	reward.scale = Vector2(0.01,0.01)
	reward.visible = true
	values.shuffle()
	label.use_parent_material = false
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(label,"material:shader_parameter/y_rot",values.pop_back(),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label,"material:shader_parameter/x_rot",values.pop_back()*2/3,1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label,"scale",Vector2(0.01,0.01),1.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(reward,"scale",Vector2(1,1),1.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
