extends Culpit

const MAX_COUNT = 10

var storing = null
var count = 0
var enabled = false


func _ready():
	._ready()
	
	if data != null:
		print("Hey it contains data")
		
		storing = data["storing"]
		count = data["count"]
		
		# update label
		$Sprite/Label.set_text(String(count))
		
		# update texture
		var texture
		if type in Global.entity_data.keys():
			print("res://arts/resources/%s.png" % storing)
			texture = load("res://arts/resources/%s.png" % storing)
		else:
			texture = load("res://arts/culpits/%s.png" % storing)
		$Sprite/Icon.set_texture(texture)


func operate(player):
	enabled = !enabled
	
	if enabled:
		$Anim.play("active")
	else:
		$Anim.stop()
	
	$Particles2D.set_emitting(enabled)
	$Particles2D2.set_emitting(enabled)


func _process(delta):
	if enabled and $DetectionArea.get_overlapping_bodies().size() > 0:
		for i in $DetectionArea.get_overlapping_bodies():
			# do nothing if box is full
			if count >= MAX_COUNT:
				# operate to turn it off
				operate(self)
				return
			
			# if currently not storing, then set the type to current
			if storing == null:
				storing = i.type
				
				var texture
				print("res://arts/resources/%s.png" % storing)
				if type in Global.entity_data.keys():
					texture = load("res://arts/resources/%s.png" % storing)
				else:
					texture = load("res://arts/culpits/%s.png" % storing)
				$Sprite/Icon.set_texture(texture)
			
			# only store if the type is the same
			if i.type == storing:
				count += 1
				#[TEMP] [FIX] so this thingy will store one object multiple time frmae
				#i.magenet_to_delete(self)
				i.queue_free()
				
				#$Label.set_text("%s [%d]" % [storing.capitalize(), count])
				$Sprite/Label.set_text(String(count))
				
				print("sucking %s at count %d" % [storing, count])


func initial_control(body):
	print("HOLDING A BOX")


func stop_control(body):
	print("stopping " + type + " from controlling")


func get_data():
	if count > 0:
		data = {
			"storing": storing,
			"count": count,
		}
		return data
	else:
		return null
