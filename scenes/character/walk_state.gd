extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50 

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction = InputEvents.movement_input()
	
	if direction == Vector2.LEFT:
		animated_sprite_2d.play("walk_left")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("walk_right")
	elif direction == Vector2.UP:
		animated_sprite_2d.play("walk_back")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_front")
		
	if direction != Vector2.ZERO:
		player.player_direction = direction
		
	player.velocity = direction * speed
	player.move_and_slide()
	
	player.position.x = clamp(player.position.x, -110, 110)
	player.position.y = clamp(player.position.y, -50, 65)


func _on_next_transitions() -> void:
	if !InputEvents.is_movement_input():
		transition.emit("Idle")
	


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
