extends Node2D

@export var speed_min: float = 20.0
@export var speed_max: float = 30.0

var clouds: Array = []
var screen_width: float = 0.0


func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	
	for child in get_children():
		if child is Sprite2D:
			var cloud_speed = randf_range(speed_min, speed_max)
			clouds.append({
				"node": child,
				"speed": cloud_speed,
				"start_y": child.position.y
			})


func _process(delta: float) -> void:
	for cloud in clouds:
		var node: Sprite2D = cloud["node"]
		node.position.x += cloud["speed"] * delta
		
		# Якщо вийшла за правий край — повернути зліва
		if node.position.x > screen_width + 50:
			node.position.x = -50
			node.position.y = cloud["start_y"] + randf_range(-10, 10)
