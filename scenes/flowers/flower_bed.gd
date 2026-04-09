extends Node2D

@onready var area: Area2D = $Area2D

var player_inside: bool = false
var planted_flower: Node2D = null
var is_empty: bool = true


func _ready() -> void:
	add_to_group("flower_beds")
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	pass


func plant_flower(flower_id: String) -> void:
	if !is_empty:
		return
	
	var data = GameData.flower_data.get(flower_id)
	if data == null:
		return
	
	var scene = load(data["scene"]) as PackedScene
	if scene == null:
		return
	
	planted_flower = scene.instantiate()
	planted_flower.position = Vector2.ZERO
	planted_flower.flower_id = flower_id
	add_child(planted_flower)
	
	is_empty = false
	
	# Сховати візуальні елементи грядки (не квітку і не Area2D)
	for child in get_children():
		if child != planted_flower and child != area:
			child.visible = false


func clear_bed() -> void:
	if planted_flower != null:
		planted_flower.queue_free()
		planted_flower = null
	is_empty = true
	
	# Показати візуальні елементи грядки
	for child in get_children():
		child.visible = true


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_inside = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside = false
