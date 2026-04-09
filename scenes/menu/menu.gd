class_name Menu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level = preload("res://scenes/game/game.tscn") as PackedScene
var click_sound_stream = preload("res://assets/music/click.mp3")
var click_player: AudioStreamPlayer


func _ready() -> void:
	click_player = AudioStreamPlayer.new()
	click_player.stream = click_sound_stream
	add_child(click_player)
	
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)


func on_start_pressed() -> void:
	click_player.play()
	await click_player.finished
	get_tree().change_scene_to_packed(start_level)


func on_exit_pressed() -> void:
	click_player.play()
	await click_player.finished
	get_tree().quit()
