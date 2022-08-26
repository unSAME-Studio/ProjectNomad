extends Culpit


var enabled = true
var current_bodies


func _process(delta):
	if enabled:
		$Sprite.rotate(10 * delta)


func operate(player):
	enabled = !enabled
	
	$Particles2D.set_emitting(enabled)
	$Light2D.set_visible(enabled)
	
	# unpowered all the current powered items
	if $DetectionArea.get_overlapping_bodies().size() > 0:
		for i in $DetectionArea.get_overlapping_bodies():
			if enabled:
				i.change_speed(0.3)
			else:
				i.change_speed(1)


func _on_DetectionArea_body_entered(body):
	if enabled:
		body.change_speed(0.3)


func _on_DetectionArea_body_exited(body):
	body.change_speed(1)
