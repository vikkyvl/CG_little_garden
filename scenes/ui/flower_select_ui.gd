extends CanvasLayer

## Меню вибору квітки для посадки

@onready var panel: PanelContainer = $PanelContainer
@onready var button_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer

var current_bed: Node2D = null
var pixel_font = preload("res://assets/fonts/pixelFont-7-8x14-sproutLands.ttf")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	add_to_group("flower_select_ui")
	
	# Внутрішні відступи панелі
	panel.add_theme_constant_override("margin_left", 12)
	panel.add_theme_constant_override("margin_right", 12)
	panel.add_theme_constant_override("margin_top", 12)
	panel.add_theme_constant_override("margin_bottom", 12)


func show_menu(bed: Node2D) -> void:
	current_bed = bed
	
	for child in button_container.get_children():
		child.queue_free()
	
	# Відступ між кнопками
	button_container.add_theme_constant_override("separation", 8)
	
	# Заголовок
	var title = Label.new()
	title.text = "Choose a flower:"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", pixel_font)
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color("#6b4c5c"))
	button_container.add_child(title)
	
	# Відступ після заголовка
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 8)
	button_container.add_child(spacer)
	
	# Кнопки квітів
	for flower_id in GameData.flower_data:
		if GameData.is_flower_unlocked(flower_id):
			var data = GameData.flower_data[flower_id]
			var btn = Button.new()
			btn.text = data["name"]
			btn.theme_type_variation = "GameMenuButton"
			btn.add_theme_font_override("font", pixel_font)
			btn.add_theme_font_size_override("font_size", 32)
			btn.custom_minimum_size = Vector2(150, 40)
			btn.pressed.connect(_on_flower_pressed.bind(flower_id))
			button_container.add_child(btn)
	
	# Кнопка закрити
	var close_btn = Button.new()
	close_btn.text = "Close"
	close_btn.theme_type_variation = "GameMenuButton"
	close_btn.add_theme_font_override("font", pixel_font)
	close_btn.add_theme_font_size_override("font_size", 32)
	close_btn.custom_minimum_size = Vector2(150, 40)
	close_btn.pressed.connect(hide_menu)
	button_container.add_child(close_btn)
	
	visible = true
	get_tree().paused = true


func hide_menu() -> void:
	visible = false
	get_tree().paused = false
	current_bed = null


func _on_flower_pressed(flower_id: String) -> void:
	if current_bed != null:
		current_bed.plant_flower(flower_id)
	hide_menu()
