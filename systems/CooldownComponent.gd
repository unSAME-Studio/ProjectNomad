extends Node2D

var cooldown = 100.0

export var speed = 5


func _process(delta):
	cooldown = clamp(cooldown + delta * speed, 0.0, 100.0)
	
	# hide UI if cooldown full
	if cooldown >= 100:
		$CanvasLayer/Control.hide()
	
	if $CanvasLayer/Control.is_visible():
		$CanvasLayer/Control.set_position(get_parent().get_global_transform_with_canvas().get_origin() - Vector2(0, 50))
	
		$CanvasLayer/Control/ProgressBar.set_value(cooldown)


func increase_cooldown(amount):
	cooldown = clamp(cooldown - amount, 0.0, 100.0)
	
	if cooldown < 100:
		$CanvasLayer/Control.show()


func can_fire(amount):
	return cooldown >= amount
