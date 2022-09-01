extends Culpit


var enabled = true
var current_bodies

func _process(delta):
	if enabled:
		$Sprite.rotate(-5 * delta)
		$DetectionArea.set_position(Vector2.ZERO)
		# check for differences
		if current_bodies != $DetectionArea.get_overlapping_bodies():
			print("|||||||     Update bodies generator")
			current_bodies = $DetectionArea.get_overlapping_bodies()
			
		#print($DetectionArea.get_overlapping_bodies())
		for i in $DetectionArea.get_overlapping_bodies():
			i.powered()



func operate(player):
	enabled = !enabled
	
	$Particles2D.set_emitting(enabled)
	$Light2D.set_visible(enabled)
	
	# unpowered all the current powered items
	if $DetectionArea.get_overlapping_bodies().size() > 0:
		for i in $DetectionArea.get_overlapping_bodies():
			if enabled:
				i.powered()
			else:
				i.unpowered()


func _on_DetectionArea_body_entered(body):
	print("%s have been powered" % body.name)
	
	#if enabled:
	#	body.powered()


func _on_DetectionArea_body_exited(body):
	body.unpowered()
