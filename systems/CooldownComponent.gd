extends Node2D

var cooldown = 100.0

export var speed = 5


func _process(delta):
	cooldown = clamp(cooldown + delta * speed, 0.0, 100.0)
	
	if $CanvasLayer/Control.is_visible():
		$CanvasLayer/Control.set_position(get_parent().get_global_transform_with_canvas().get_origin())
	
		$CanvasLayer/Control/ProgressBar.set_value(cooldown)


func increase_cooldown(amount):
	cooldown = clamp(cooldown - amount, 0.0, 100.0)


func can_fire(amount):
	return cooldown >= amount
