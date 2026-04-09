#extends Node2D
#
#@export var flower_id: String = "rose"
#@export var wait_time: float = 10.0
#@export var max_stages: int = 3
#
#@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var area: Area2D = $Area2D
#@onready var timer_label: Label = $Label
#@onready var progress_bar: TextureProgressBar = $TextureProgressBar
#@onready var water_icon: Sprite2D = $WaterIcon
#@onready var reset_timer: Timer = $Timer
#
#var time_left: float = 0.0
#var can_water: bool = false
#var player_inside: bool = false
#var current_stage: int = 0
#var is_fully_grown: bool = false
#var waiting_to_collect: bool = false
#var icon_base_y: float = 0.0
#var anim_time: float = 0.0
#
#
#func _ready() -> void:
	#add_to_group("flowers")
	#
	#progress_bar.min_value = 0
	#progress_bar.max_value = wait_time
	#progress_bar.value = 0
	#
	#reset_timer.one_shot = true
	#reset_timer.wait_time = 3.0
	#reset_timer.timeout.connect(_on_reset_timeout)
	#
	#time_left = wait_time
	#can_water = false
	#
	#sprite.stop()
	#sprite.animation = "default"
	#sprite.frame = 0
	#
	#area.body_entered.connect(_on_body_entered)
	#area.body_exited.connect(_on_body_exited)
	#water_icon.visible = false
	#icon_base_y = water_icon.position.y
	#
	#_update_ui()
#
#
#func _process(delta: float) -> void:
	#if !is_fully_grown and !can_water:
		#time_left -= delta
		#if time_left <= 0.0:
			#time_left = 0.0
			#can_water = true
	#
	## Анімація іконки — покачування вгору-вниз
	#if water_icon.visible:
		#anim_time += delta * 3.0
		#water_icon.position.y = icon_base_y + sin(anim_time) * 2.0
	#
	#_update_ui()
#
#
#func _update_ui() -> void:
	#if waiting_to_collect:
		#timer_label.text = ""
		#progress_bar.visible = false
		#water_icon.visible = false
	#elif can_water and !is_fully_grown:
		#timer_label.text = ""
		#progress_bar.value = progress_bar.max_value
		#progress_bar.visible = true
		#water_icon.visible = true
	#elif is_fully_grown:
		#timer_label.text = ""
		#progress_bar.visible = false
		#water_icon.visible = false
	#else:
		#timer_label.text = ""
		#progress_bar.value = wait_time - time_left
		#progress_bar.visible = true
		#water_icon.visible = false
#
#
#func try_water() -> bool:
	#if !player_inside:
		#return false
	#
	#if waiting_to_collect:
		#_collect_flower()
		#return true
	#
	#if !can_water:
		#return false
	#if is_fully_grown:
		#return false
	#
	#can_water = false
	#current_stage += 1
	#sprite.frame = current_stage
	#progress_bar.value = 0
	#
	#if current_stage >= max_stages:
		#is_fully_grown = true
		#progress_bar.visible = false
		#timer_label.text = ""
		#water_icon.visible = false
		#
		#var reward = GameData.get_reward(flower_id)
		#GameData.add_coins(reward)
		#print("Flower grown! +" + str(reward) + " coins")
		#
		## Думка над котиком
		#var player_node = get_tree().get_first_node_in_group("player")
		#if player_node:
			#var bubble_scene = load("res://scenes/ui/thought_bubble.tscn")
			#var bubble = bubble_scene.instantiate()
			#bubble.show_on(player_node, "+" + str(reward) + " !")
		#
		#var dialog = get_tree().get_first_node_in_group("flower_dialog")
		#if dialog:
			#dialog.show_dialog(flower_id, reward, get_parent())
		#
		#waiting_to_collect = true
	#else:
		#time_left = wait_time
	#
	#return true
#
#
#func _collect_flower() -> void:
	#var parent = get_parent()
	#if parent.has_method("clear_bed"):
		#parent.clear_bed()
	#else:
		#_reset_flower()
#
#
#func _on_reset_timeout() -> void:
	#var parent = get_parent()
	#if parent.has_method("clear_bed"):
		#parent.clear_bed()
	#else:
		#_reset_flower()
#
#
#func _reset_flower() -> void:
	#current_stage = 0
	#is_fully_grown = false
	#can_water = false
	#waiting_to_collect = false
	#time_left = wait_time
	#sprite.frame = 0
	#progress_bar.value = 0
	#progress_bar.visible = true
	#timer_label.text = ""
	#water_icon.visible = false
#
#
#func _on_body_entered(body: Node2D) -> void:
	#if body is Player:
		#player_inside = true
#
#
#func _on_body_exited(body: Node2D) -> void:
	#if body is Player:
		#player_inside = false
extends Node2D

@export var flower_id: String = "rose"
@export var wait_time: float = 10.0
@export var max_stages: int = 3

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D
@onready var timer_label: Label = $Label
@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@onready var water_icon: Sprite2D = $WaterIcon
@onready var water_sound: AudioStreamPlayer = $WaterSound
@onready var coin_sound: AudioStreamPlayer = $CoinSound
@onready var reset_timer: Timer = $Timer

var time_left: float = 0.0
var can_water: bool = false
var player_inside: bool = false
var current_stage: int = 0
var is_fully_grown: bool = false
var waiting_to_collect: bool = false
var icon_base_y: float = 0.0
var anim_time: float = 0.0


func _ready() -> void:
	add_to_group("flowers")
	
	progress_bar.min_value = 0
	progress_bar.max_value = wait_time
	progress_bar.value = 0
	
	reset_timer.one_shot = true
	reset_timer.wait_time = 3.0
	reset_timer.timeout.connect(_on_reset_timeout)
	
	time_left = wait_time
	can_water = false
	
	sprite.stop()
	sprite.animation = "default"
	sprite.frame = 0
	
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	water_icon.visible = false
	icon_base_y = water_icon.position.y
	
	_update_ui()


func _process(delta: float) -> void:
	if !is_fully_grown and !can_water:
		time_left -= delta
		if time_left <= 0.0:
			time_left = 0.0
			can_water = true
	
	# Анімація іконки — покачування вгору-вниз
	if water_icon.visible:
		anim_time += delta * 3.0
		water_icon.position.y = icon_base_y + sin(anim_time) * 2.0
	
	_update_ui()


func _update_ui() -> void:
	if waiting_to_collect:
		timer_label.text = ""
		progress_bar.visible = false
		water_icon.visible = false
	elif can_water and !is_fully_grown:
		timer_label.text = ""
		progress_bar.value = progress_bar.max_value
		progress_bar.visible = true
		water_icon.visible = true
	elif is_fully_grown:
		timer_label.text = ""
		progress_bar.visible = false
		water_icon.visible = false
	else:
		timer_label.text = ""
		progress_bar.value = wait_time - time_left
		progress_bar.visible = true
		water_icon.visible = false


func try_water() -> bool:
	if !player_inside:
		return false
	
	if waiting_to_collect:
		_collect_flower()
		return true
	
	if !can_water:
		return false
	if is_fully_grown:
		return false
	
	can_water = false
	current_stage += 1
	sprite.frame = current_stage
	progress_bar.value = 0
	water_sound.play()
	
	if current_stage >= max_stages:
		is_fully_grown = true
		progress_bar.visible = false
		timer_label.text = ""
		water_icon.visible = false
		
		var reward = GameData.get_reward(flower_id)
		GameData.add_coins(reward)
		coin_sound.play()
		print("Flower grown! +" + str(reward) + " coins")
		
		# Думка над котиком
		var player_node = get_tree().get_first_node_in_group("player")
		if player_node:
			var bubble_scene = load("res://scenes/ui/thought_bubble.tscn")
			var bubble = bubble_scene.instantiate()
			bubble.show_on(player_node, "+" + str(reward) + " !")
		
		var dialog = get_tree().get_first_node_in_group("flower_dialog")
		if dialog:
			dialog.show_dialog(flower_id, reward, get_parent())
		
		waiting_to_collect = true
	else:
		time_left = wait_time
	
	return true


func _collect_flower() -> void:
	var parent = get_parent()
	if parent.has_method("clear_bed"):
		parent.clear_bed()
	else:
		_reset_flower()


func _on_reset_timeout() -> void:
	var parent = get_parent()
	if parent.has_method("clear_bed"):
		parent.clear_bed()
	else:
		_reset_flower()


func _reset_flower() -> void:
	current_stage = 0
	is_fully_grown = false
	can_water = false
	waiting_to_collect = false
	time_left = wait_time
	sprite.frame = 0
	progress_bar.value = 0
	progress_bar.visible = true
	timer_label.text = ""
	water_icon.visible = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_inside = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside = false
