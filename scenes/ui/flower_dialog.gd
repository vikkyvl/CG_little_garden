#extends CanvasLayer
#
### Діалогове вікно після вирощування квітки
#
#@onready var panel: PanelContainer = $PanelContainer
#@onready var container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
#@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/TitleLabel
#@onready var reward_label: Label = $PanelContainer/MarginContainer/VBoxContainer/RewardLabel
#@onready var collect_button: Button = $PanelContainer/MarginContainer/VBoxContainer/CollectButton
#@onready var keep_button: Button = $PanelContainer/MarginContainer/VBoxContainer/KeepButton
#
#var current_bed: Node2D = null
#
#
#func _ready() -> void:
	#process_mode = Node.PROCESS_MODE_ALWAYS
	#visible = false
	#add_to_group("flower_dialog")
	#
	#collect_button.pressed.connect(_on_collect)
	#keep_button.pressed.connect(_on_keep)
#
#
#func show_dialog(flower_id: String, reward: int, bed: Node2D) -> void:
	#current_bed = bed
	#
	#var data = GameData.flower_data.get(flower_id)
	#var flower_name = data["name"] if data else flower_id
	#
	#title_label.text = "Congrats! You grew a " + flower_name + "!"
	#reward_label.text = "+" + str(reward) + " coins"
	#
	#visible = true
	#get_tree().paused = true
#
#
#func _on_collect() -> void:
	#if current_bed != null and current_bed.has_method("clear_bed"):
		#current_bed.clear_bed()
	#
	#visible = false
	#get_tree().paused = false
	#current_bed = null
#
#
#func _on_keep() -> void:
	#if current_bed != null and current_bed.planted_flower != null:
		#current_bed.planted_flower.waiting_to_collect = true
		#current_bed.planted_flower.timer_label.text = "Collect!"
	#
	#visible = false
	#get_tree().paused = false
	#current_bed = null
extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer
@onready var title_label: Label = $PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var reward_label: Label = $PanelContainer/MarginContainer/VBoxContainer/RewardLabel
@onready var collect_button: Button = $PanelContainer/MarginContainer/VBoxContainer/CollectButton
@onready var keep_button: Button = $PanelContainer/MarginContainer/VBoxContainer/KeepButton
@onready var click_sound: AudioStreamPlayer = $CoinSound

var current_bed: Node2D = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	add_to_group("flower_dialog")
	
	collect_button.pressed.connect(_on_collect)
	keep_button.pressed.connect(_on_keep)


func show_dialog(flower_id: String, reward: int, bed: Node2D) -> void:
	current_bed = bed
	
	var data = GameData.flower_data.get(flower_id)
	var flower_name = data["name"] if data else flower_id
	
	title_label.text = "Congrats! You grew a " + flower_name + "!"
	reward_label.text = "+" + str(reward) + " coins"
	
	visible = true
	get_tree().paused = true


func _on_collect() -> void:
	click_sound.play()
	if current_bed != null and current_bed.has_method("clear_bed"):
		current_bed.clear_bed()
	
	visible = false
	get_tree().paused = false
	current_bed = null


func _on_keep() -> void:
	click_sound.play()
	if current_bed != null and current_bed.planted_flower != null:
		current_bed.planted_flower.waiting_to_collect = true
	
	visible = false
	get_tree().paused = false
	current_bed = null
