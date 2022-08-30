extends Culpit


var enabled = true
var current_bodies

func _process(delta):
	pass
#	if enabled:
#		$Sprite.rotate(-5 * delta)
#
#		# check for differences
#		if current_bodies != $DetectionArea.get_overlapping_bodies():
#			print("|||||||     Update bodies generator")
#			current_bodies = $DetectionArea.get_overlapping_bodies()
#
#		#print($DetectionArea.get_overlapping_bodies())
#		for i in $DetectionArea.get_overlapping_bodies():
#			i.powered()



func operate(player):
	#enabled = !enabled
	
	$Particles2D.set_emitting(enabled)
	
	# unpowered all the current powered items
	if $DetectionArea.get_overlapping_bodies().size() > 1:
		for i in $DetectionArea.get_overlapping_bodies():
			if i != self:
				if i.has_method('operate'):
					i.operate(player)



func _on_DetectionArea_body_entered(body):
	pass
	
	#if enabled:
	#	body.powered()


func _on_DetectionArea_body_exited(body):
	pass
