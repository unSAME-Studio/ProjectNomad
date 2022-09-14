extends Culpit


var enabled = true
var current_bodies

func _process(delta):
	if enabled:
		$Sprite.rotate(-5 * delta)
		$DetectionArea.set_position(Vector2.ZERO)
		#print($DetectionArea.get_overlapping_bodies())
		for i in $DetectionArea.get_overlapping_bodies():
			if i. has_method('buff'):
				i.buff('rate',self)



func operate(player):
	enabled = !enabled
	
	$Particles2D.set_emitting(enabled)
	$Particles2D.set_visible(enabled)
	$Light2D.set_visible(enabled)


