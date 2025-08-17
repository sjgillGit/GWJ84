extends Panel
@onready var button_show: Panel = $Container/HBoxContainer/column2/hotkeyhelp/button_show
@onready var hotkeyhelpcheck: CheckBox = $Container/HBoxContainer/column2/hotkeyhelp/hotkeyhelpcheck
@export var hide_help: bool = false
@onready var sensitive_value: Label = $Container/HBoxContainer/column2/sensitive_value
@onready var sensitive_slide: HSlider = $Container/HBoxContainer/column2/sensitive_slide
@onready var click: AudioStreamPlayer = $click
@onready var roll: AudioStreamPlayer = $roll
@onready var master_slide: HSlider = $Container/HBoxContainer/column/master_slide
@onready var music_slide: HSlider = $Container/HBoxContainer/column/music_slide
@onready var sfx_slide: HSlider = $Container/HBoxContainer/column/sfx_slide
@onready var hover: AudioStreamPlayer = $hover
var save_path_full = "user://GWJ/settings.json"


var save_data
func _ready() -> void:
	
	if !FileAccess.file_exists(save_path_full):
		var save_path = "user://GWJ"
		var save_file_name = "settings.json"
		var full_path = save_path + "/" + save_file_name
		create_save(save_path,save_file_name,full_path)
		var save_file = load(save_path_full)
		save_data = save_file.data
	else:
		var save_file = load(save_path_full)
		save_data = save_file.data
		load_buttons()
func load_buttons():
	GlobalSettings.camera_sensivity = save_data["camera_sensitivity"]/10
	GlobalSettings.hotkey_help = save_data["hotkey_help"]
	hotkeyhelpcheck.button_pressed = save_data["hotkey_help"]
	hide_help = !save_data["hotkey_help"]
	print(save_data["hotkey_help"])
	if hide_help == true: button_show.modulate = Color(1,1,1,0)
	else: button_show.modulate = Color(1,1,1,1)
	master_slide.value = save_data["master_volume"]
	music_slide.value = save_data["music_volume"]
	sfx_slide.value = save_data["sfx_volume"]
	sensitive_slide.value = save_data["camera_sensitivity"]
func create_save(savepath,namesave,fullpath):
	var dictionar = {
		"music_volume": 1,
		"sfx_volume": 1,
		"master_volume": 1,
		"camera_sensitivity": 0.15,
		"hotkey_help": true}
	if not DirAccess.dir_exists_absolute(savepath):
		DirAccess.make_dir_absolute(savepath)
	var file = FileAccess.open(fullpath, FileAccess.WRITE)
	var json_text = JSON.stringify(dictionar, "\t")
	file.store_string(json_text)
	
func save():
	var file = FileAccess.open(save_path_full, FileAccess.WRITE)
	var jsonstring = JSON.stringify(save_data, "\t")
	file.store_string(jsonstring)



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("HideKeyIndicators"):
		click.play()
		hotkeyhelpcheck.button_pressed = hide_help
		button_show.button_clicked()
		#hide_help = !toggled_on
		if hide_help == true: button_show.modulate = Color(1,1,1,0)
		else: button_show.modulate = Color(1,1,1,1)
		save()


func _on_hotkeyhelpcheck_toggled(toggled_on: bool) -> void:
	click.play()
	GlobalSettings.hotkey_help = toggled_on
	hide_help = !toggled_on
	if hide_help == true: button_show.modulate = Color(1,1,1,0)
	else: button_show.modulate = Color(1,1,1,1)
	save_data["hotkey_help"] = !hide_help
	save()

func _process(delta: float) -> void:
	sensitive_value.text = str(int(sensitive_slide.value*10))


func _on_close_button_pressed() -> void:
	click.play()
	self.visible = false

func _on_master_slide_value_changed(value: float) -> void:
	roll.play()
	AudioServer.set_bus_volume_linear(0,value)
	AudioServer.set_bus_mute(0,value < 0.01)
	save_data["master_volume"] = value
	save()
func _on_music_slide_value_changed(value: float) -> void:
	roll.play()
	AudioServer.set_bus_volume_linear(2,value)
	AudioServer.set_bus_mute(2,value < 0.01)
	save_data["music_volume"] = value
	save()
func _on_sfx_slide_value_changed(value: float) -> void:
	roll.play()
	AudioServer.set_bus_volume_linear(1,value)
	AudioServer.set_bus_mute(1,value < 0.01)
	save_data["sfx_volume"] = value
	save()

func _on_sensitive_slide_value_changed(value: float) -> void:
	roll.play()
	GlobalSettings.camera_sensivity = value/10
	save_data["camera_sensitivity"] = value
	#print(value/10)
	save()
func _on_close_button_mouse_entered() -> void:
	hover.play()
