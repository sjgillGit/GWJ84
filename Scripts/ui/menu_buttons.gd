extends VBoxContainer
@onready var settings: Panel = $"../settings"
@onready var click: AudioStreamPlayer = $"../settings/click"
@onready var hover: AudioStreamPlayer = $"../settings/hover"
@onready var credits: Panel = $"../credits"
@onready var fade: ColorRect = $"../fade"
@onready var title_music: AudioStreamPlayer = $"../title_music"

func _on_settings_pressed() -> void:
	settings.visible = ! settings.visible
	click.play()
	
func _on_startgame_pressed() -> void:
	click.play()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(fade,"modulate",Color(1,1,1,1),1).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(title_music,"volume_linear",0,0.7).set_trans(Tween.TRANS_CIRC)
	
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
func _on_quit_pressed() -> void:
	click.play()
	get_tree().quit()
func _on_startgame_mouse_entered() -> void:
	hover.play()

func _on_settings_mouse_entered() -> void:
	hover.play()

func _on_quit_mouse_entered() -> void:
	hover.play()

func _on_credits_pressed() -> void:
	click.play()
	credits.visible = !credits.visible 
	
func _on_credits_mouse_entered() -> void:
	hover.play()
