extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var is_collecting: bool = false


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if is_collecting:
		# Збирання — одразу назад в Idle без анімації
		transition.emit("Idle")
		return
	
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")


func _on_enter() -> void:
	is_collecting = false
	
	# Перевірити чи це збирання чи полив
	var flowers = player.get_tree().get_nodes_in_group("flowers")
	for flower in flowers:
		if flower.player_inside and flower.waiting_to_collect:
			# Збирання — без анімації
			flower.try_water()
			is_collecting = true
			return
	
	# Полив — з анімацією
	_try_water_nearest_flower()
	
	if player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("watering_left")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("watering_right")
	elif player.player_direction == Vector2.UP:
		animated_sprite_2d.play("watering_back")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("watering_front")
	else:
		animated_sprite_2d.play("watering_front")


func _on_exit() -> void:
	animated_sprite_2d.stop()
	is_collecting = false


func _try_water_nearest_flower() -> void:
	var flowers = player.get_tree().get_nodes_in_group("flowers")
	for flower in flowers:
		if flower.has_method("try_water"):
			if flower.try_water():
				return
