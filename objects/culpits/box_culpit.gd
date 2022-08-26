extends Culpit

const MAX_COUNT = 10

var storing = null
var count = 0
var enabled = false


func _ready():
	if data != null:
		print("Hey it contains data")
		
		storing = data["storing"]
		count = data["count"]
		
		# update label
		$Sprite/Label.set_text(String(count))
		
		# update texture
		var texture
		if Global.entity_data.keys().has(storing):
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
		$Anim.play("finished")
	
	$Particles2D.set_emitting(enabled)
	$Particles2D2.set_emitting(enabled)
	$Light2D.set_visible(enabled)


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
				if Global.entity_data.keys().has(storing):
					texture = load("res://arts/resources/%s.png" % storing)
				else:
					texture = load("res://arts/culpits/%s.png" % storing)
				$Sprite/Icon.set_texture(texture)
			
			# only store if the type is the same
			if i.type == storing:
				
				#[TEMP] [FIX] so this thingy will store one object multiple time frmae
				#i.magenet_to_delete(self)
				apply_magnet(i)
				if get_global_position().distance_to(i.get_global_position()) < 10:
					i.queue_free()
					count += 1
				
					#$Label.set_text("%s [%d]" % [storing.capitalize(), count])
					$Sprite/Label.set_text(String(count))
					
					print("sucking %s at count %d" % [storing, count])
					
					# update player ui (kinda sketch
					user.storage_ui[user.wearing].update_box_info(storing, count)

func apply_magnet(target):
	target.throwing = true
	target.velocity += (get_global_position() - target.get_global_position()).normalized()*15#(target.get_parent().to_local(get_global_position()) - target.get_position()).normalized()*10
	#return get_global_position().distance_to(target.get_global_position())
	#print((target.get_parent().to_local(get_global_position()) - target.get_position()))

func initial_control(body):
	user = body
	
	if not wearing:
		var temp_type = storing
		
		if use_storing():
			# spawn entity
			var e = entity.instance()

			e.type = temp_type
			base.add_child(e)
			
			e.set_global_position(get_global_position())
			e.set_wearing(false)
			e.velocity = Vector2.DOWN.rotated(get_rotation()).normalized() * 1000
			e.throwing = true


func use_storing() -> bool:
	if count > 0:
		count -= 1
		$Sprite/Label.set_text(String(count))
		
		# update player ui (kinda sketch
		#user.storage_ui[user.wearing].update_box_info(storing, count)
		
		# clear graphic if empty
		if count == 0:
			$Sprite/Icon.set_texture(Texture.new())
			storing = null
		
		return true
	
	return false


func get_data():
	if count > 0:
		data = {
			"storing": storing,
			"count": count,
		}
		return data
	else:
		return null


func _on_VisibilityEnabler2D_screen_entered():
	if enabled:
		$Particles2D.set_emitting(true)
		$Particles2D2.set_emitting(true)


func _on_VisibilityEnabler2D_screen_exited():
	$Particles2D.set_emitting(false)
	$Particles2D2.set_emitting(false)
