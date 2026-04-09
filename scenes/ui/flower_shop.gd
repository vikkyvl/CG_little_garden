extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var coins_label: Label = $PanelContainer/MarginContainer/VBoxContainer/CoinsLabel
@onready var items_container = $PanelContainer/MarginContainer/VBoxContainer/GridContainer
@onready var close_button: Button = $PanelContainer/MarginContainer/VBoxContainer/CloseButton


var button_icons: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	add_to_group("flower_shop")
	
	close_button.pressed.connect(hide_shop)
	GameData.coins_changed.connect(_on_coins_changed)
	
	# Під'єднати кнопки і зберегти їх іконки
	for flower_id in GameData.flower_data:
		var btn = items_container.find_child(flower_id, true, false)
		if btn and btn is Button:
			btn.pressed.connect(_buy.bind(flower_id))
			button_icons[flower_id] = btn.icon


func show_shop() -> void:
	_refresh_buttons()
	coins_label.text = "Your coins: " + str(GameData.coins)
	visible = true
	get_tree().paused = true


func hide_shop() -> void:
	visible = false
	get_tree().paused = false


func _refresh_buttons() -> void:
	for flower_id in GameData.flower_data:
		var btn = items_container.find_child(flower_id, true, false)
		if btn == null or !(btn is Button):
			continue
		
		var data = GameData.flower_data[flower_id]
		
		if GameData.is_flower_unlocked(flower_id):
			btn.text = "Owned"
			btn.icon = null
			btn.disabled = true
		elif GameData.coins >= data["price"]:
			btn.text = str(data["price"])
			btn.icon = button_icons.get(flower_id)
			btn.disabled = false
		else:
			btn.text = "Not available"
			btn.icon = null
			btn.disabled = true


func _buy(flower_id: String) -> void:
	if GameData.unlock_flower(flower_id):
		_refresh_buttons()
		coins_label.text = "Your coins: " + str(GameData.coins)


func _on_coins_changed(_amount: int) -> void:
	if visible:
		coins_label.text = "Your coins: " + str(GameData.coins)
		_refresh_buttons()
