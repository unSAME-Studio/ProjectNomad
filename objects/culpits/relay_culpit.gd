extends Culpit


var enabled = true
var current_bodies
var cd = false

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
	if not cd:
		cd = true
		$Particles2D.set_emitting(enabled)
		$DetectionArea.set_position(Vector2.ZERO)
		if $DetectionArea.get_overlapping_bodies().size() > 1:
			for i in $DetectionArea.get_overlapping_bodies():
				if i.has_method('operate'):
#					if 'cd' in i:
#						if i.cd == false:
#							i.operate(player)
#					else:
					i.operate(player)
		yield(get_tree(), "idle_frame")
		cd = false



func _on_DetectionArea_body_entered(body):
	pass
	
	#if enabled:
	#	body.powered()


func _on_DetectionArea_body_exited(body):
	pass
