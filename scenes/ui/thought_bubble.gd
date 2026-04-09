extends Node2D

@onready var label: Label = $Label


func show_on(target: Node2D, text: String) -> void:
	target.add_child(self)
	$Label.text = text
	
	# Анімація: з'являється знизу вгору і зникає
	var start_y = position.y
	position.y = start_y + 5
	modulate.a = 0.0
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	tween.tween_property(self, "position:y", start_y, 0.3).set_ease(Tween.EASE_OUT)
	tween.chain().tween_interval(1.5)
	tween.chain().tween_property(self, "modulate:a", 0.0, 0.4)
	tween.chain().tween_callback(queue_free)
