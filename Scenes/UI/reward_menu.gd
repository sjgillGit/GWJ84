extends Panel
var smash_count:= 0
@onready var show_reward: Control = $MarginContainer/VBoxContainer/show_reward
@onready var smash_1: Label = $MarginContainer/VBoxContainer/separator/smash_1
@onready var separator: Control = $MarginContainer/VBoxContainer/separator
@onready var new_sepatator: Control = $"MarginContainer/VBoxContainer/new sepatator"
@onready var smash_2: Label = $MarginContainer/VBoxContainer/separator/smash_2
@onready var smash_3: Label = $MarginContainer/VBoxContainer/separator/smash_3
@onready var origin_pos: Vector2 = self.position
@onready var gpu_particles_2d: GPUParticles2D = $MarginContainer/VBoxContainer/Label/GPUParticles2D
@onready var gpu_particles_2d_2: GPUParticles2D = $MarginContainer/VBoxContainer/Label/GPUParticles2D2
var values = [20,-15,-20,25,17,-13]
func _on_smash_button_pressed() -> void:
	print(smash_1)
	match smash_count:
		0:
			smash_me(smash_1)
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(self,"position",origin_pos + Vector2(5,15),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self,"scale",Vector2(1.02,1.02),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		1:
			smash_me(smash_2)
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(self,"position",origin_pos + Vector2(13,-3),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self,"scale",Vector2(1.04,1.04),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		2:
			smash_me(smash_3)
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(self,"position",origin_pos + Vector2(-10,7),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self,"scale",Vector2(1.08,1.08),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		3:
			separator.pivot_offset = Vector2(230,200)
			show_reward.scale = Vector2(0.01,0.01)
			new_sepatator.pivot_offset = Vector2(230,200)
			show_reward.pivot_offset = Vector2(230,175)
			new_sepatator.scale = Vector2(0.01,0.01)
			new_sepatator.modulate = Color(1,1,1,1)
			show_reward.modulate = Color(1,1,1,1)
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(self,"position",origin_pos,0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(self,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(separator,"scale",Vector2(0.01,0.01),1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(new_sepatator,"scale",Vector2(1,1),2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(show_reward,"scale",Vector2(1,1),2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			gpu_particles_2d.emitting = true
			gpu_particles_2d_2.emitting = true
			await tween.finished
			separator.visible = false
			
	smash_count += 1

func smash_me(label: Label):
	values.shuffle()
	label.use_parent_material = false
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(label,"material:shader_parameter/y_rot",values.pop_back(),0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label,"material:shader_parameter/x_rot",values.pop_back()*2/3,1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
