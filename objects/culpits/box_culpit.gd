extends Culpit


var storing = null
var count = 0
var enabled = false


func operate(player):
	enabled = !enabled
	
	if enabled:
		$Anim.play("active")
	else:
		$Anim.stop()


func _process(delta):
	if enabled and $DetectionArea.get_overlapping_bodies().size() > 0:
		for i in $DetectionArea.get_overlapping_bodies():
			# do nothing if box is full
			if count >= 5:
				return
			
			# if currently not storing, then set the type to current
			if storing == null:
				storing = i.type
			
			# only store if the type is the same
			if i.type == storing:
				count += 1
				i.magenet_to_delete(self)
				
				$Label.set_text("%s [%d]" % [storing.capitalize(), count])
				
				print("sucking %s at count %d" % [storing, count])


func initial_control(body):
	print("HOLDING A BOX")


func stop_control(body):
	print("stopping " + type + " from controlling")
