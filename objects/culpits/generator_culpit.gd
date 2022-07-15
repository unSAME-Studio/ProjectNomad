extends Culpit


var enabled = true


func _process(delta):
	if enabled:
		$Sprite.rotate(-5 * delta)


func operate(player):
	enabled = !enabled
	
	$Particles2D.set_emitting(enabled)
	
	# unpowered all the current powered items
	if $DetectionArea.get_overlapping_bodies().size() > 0:
		for i in $DetectionArea.get_overlapping_bodies():
			if enabled:
				i.powered()
			else:
				i.unpowered()


func initial_control(body):
	if not wearing:
		operate(body)


func stop_control(body):
	print("stopping " + type + " from controlling")


func _on_DetectionArea_body_entered(body):
	print("%s have been powered" % body.name)
	
	if enabled:
		body.powered()


func _on_DetectionArea_body_exited(body):
	body.unpowered()
