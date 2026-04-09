extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:	
	if player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_right")
	elif player.player_direction == Vector2.UP:
		animated_sprite_2d.play("idle_back")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	else:
		animated_sprite_2d.play("idle_front")


func _on_next_transitions() -> void:
	InputEvents.movement_input()
	
	if InputEvents.is_movement_input():
		transition.emit("Walk")
	
	if InputEvents.use_tool():
		# 1. Зібрати квітку — прямо тут, без Watering
		if _try_collect_flower():
			return
		
		if player.current_tool == DataTypes.Tools.WaterCrops:
			# 2. Полити квітку — через Watering з анімацією
			if _can_water_any_flower():
				transition.emit("Watering")
				return
			
			# 3. Посадити на порожню грядку
			_try_open_plant_menu()


func _on_enter() -> void:
	animated_sprite_2d.stop()


func _on_exit() -> void:
	pass


## Зібрати квітку — прямо з Idle, без анімації
func _try_collect_flower() -> bool:
	var flowers = player.get_tree().get_nodes_in_group("flowers")
	for flower in flowers:
		if flower.player_inside and flower.waiting_to_collect:
			flower._collect_flower()
			return true
	return false


func _can_water_any_flower() -> bool:
	var flowers = player.get_tree().get_nodes_in_group("flowers")
	for flower in flowers:
		if flower.player_inside and flower.can_water and !flower.is_fully_grown:
			return true
	return false


func _try_open_plant_menu() -> void:
	var beds = player.get_tree().get_nodes_in_group("flower_beds")
	for bed in beds:
		if bed.player_inside and bed.is_empty:
			var ui = player.get_tree().get_first_node_in_group("flower_select_ui")
			if ui:
				ui.show_menu(bed)
			return
