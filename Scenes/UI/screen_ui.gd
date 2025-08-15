extends CanvasLayer
@onready var skill_box: HBoxContainer = $skill_box
@onready var watch: CanvasGroup = $watch

func _ready() -> void:
	set_resolution()

func set_resolution():
	skill_box.position.y = get_viewport().get_visible_rect().size.y - 88 
	skill_box.position.x =  get_viewport().get_visible_rect().size.x - 180
	watch.get_child(0).resolution_set()
