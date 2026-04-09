extends Node

const SAVE_PATH = "user://save_data.cfg"

var click_sound_stream = preload("res://assets/music/click.mp3")
var click_player: AudioStreamPlayer

# Монети гравця
var coins: int = 0

# Які квіти відкриті
var unlocked_flowers: Dictionary = {
	"rose": true
}

# Дані квітів
var flower_data: Dictionary = {
	"rose": {
		"name": "Rose",
		"price": 0,
		"reward": 10,
		"scene": "res://scenes/flowers/rose.tscn"
	},
	"tulip": {
		"name": "Tulip",
		"price": 15,
		"reward": 15,
		"scene": "res://scenes/flowers/tulip.tscn"
	},
	"sunflower": {
		"name": "Sunflower",
		"price": 30,
		"reward": 25,
		"scene": "res://scenes/flowers/sunflower.tscn"
	},
	"dandelion": {
		"name": "Dandelion",
		"price": 20,
		"reward": 20,
		"scene": "res://scenes/flowers/dandelion.tscn"
	},
	"daisy": {
		"name": "Daisy",
		"price": 25,
		"reward": 20,
		"scene": "res://scenes/flowers/daisy.tscn"
	},
	"orchid": {
		"name": "Orchid",
		"price": 35,
		"reward": 30,
		"scene": "res://scenes/flowers/orchid.tscn"
	},
	"bluebell": {
		"name": "Bluebell",
		"price": 20,
		"reward": 15,
		"scene": "res://scenes/flowers/bluebell.tscn"
	},
	"iris": {
		"name": "Iris",
		"price": 30,
		"reward": 25,
		"scene": "res://scenes/flowers/iris.tscn"
	}
}

signal coins_changed(new_amount: int)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_game()
	
	# Глобальний звук кліку
	click_player = AudioStreamPlayer.new()
	click_player.stream = click_sound_stream
	click_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(click_player)
	
	# Автоматично додавати звук до всіх кнопок
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	if node is Button:
		node.pressed.connect(_play_click)


func _play_click() -> void:
	click_player.play()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()


func add_coins(amount: int) -> void:
	coins += amount
	coins_changed.emit(coins)
	save_game()


func spend_coins(amount: int) -> bool:
	if coins >= amount:
		coins -= amount
		coins_changed.emit(coins)
		save_game()
		return true
	return false


func unlock_flower(flower_id: String) -> bool:
	if unlocked_flowers.has(flower_id):
		return false
	
	var data = flower_data.get(flower_id)
	if data == null:
		return false
	
	if spend_coins(data["price"]):
		unlocked_flowers[flower_id] = true
		save_game()
		return true
	
	return false


func is_flower_unlocked(flower_id: String) -> bool:
	return unlocked_flowers.has(flower_id)


func get_reward(flower_id: String) -> int:
	var data = flower_data.get(flower_id)
	if data:
		return data["reward"]
	return 0


# ===== ЗБЕРЕЖЕННЯ / ЗАВАНТАЖЕННЯ =====

func save_game() -> void:
	var config = ConfigFile.new()
	config.set_value("player", "coins", coins)
	var unlocked_list: Array = unlocked_flowers.keys()
	config.set_value("player", "unlocked_flowers", unlocked_list)
	config.save(SAVE_PATH)
	print("Гру збережено! Монети: ", coins)


func load_game() -> void:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	
	if err != OK:
		print("Збереження не знайдено — нова гра")
		return
	
	coins = config.get_value("player", "coins", 0)
	
	var unlocked_list = config.get_value("player", "unlocked_flowers", ["rose"])
	unlocked_flowers.clear()
	for flower_id in unlocked_list:
		unlocked_flowers[flower_id] = true
	
	print("Гру завантажено! Монети: ", coins)
	coins_changed.emit(coins)
