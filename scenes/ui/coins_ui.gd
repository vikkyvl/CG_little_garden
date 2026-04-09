extends CanvasLayer

@onready var coins_label: Label = $MarginContainer/HBoxContainer/CoinsLabel
@onready var shop_button: Button = $MarginContainer/VBoxContainer/ShopButton
@onready var menu_button: Button = $MarginContainer/VBoxContainer/MenuButton
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/VolumeSlider


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_update_coins(GameData.coins)
	GameData.coins_changed.connect(_update_coins)
	
	shop_button.pressed.connect(_on_shop)
	menu_button.pressed.connect(_on_menu)
	
	volume_slider.min_value = 0
	volume_slider.max_value = 100
	volume_slider.value = 50
	volume_slider.gui_input.connect(_on_volume_input)


func _update_coins(amount: int) -> void:
	coins_label.text = str(amount) 


func _on_shop() -> void:
	var shop = get_tree().get_first_node_in_group("flower_shop")
	if shop:
		shop.show_shop()


func _on_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_volume_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var ratio = event.position.x / volume_slider.size.x
		volume_slider.value = ratio * 100.0
		_apply_volume(volume_slider.value)
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var ratio = event.position.x / volume_slider.size.x
		volume_slider.value = clamp(ratio * 100.0, 0, 100)
		_apply_volume(volume_slider.value)


func _apply_volume(value: float) -> void:
	var db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(0, db)
	if value == 0:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
