extends Culpit

const MAX_COUNT = 30

var controlling = false
var storing = null
var count = 0
var enabled = false

var in_cd = false

func _ready():
	return 
	
	var texture = load("res://arts/resources/nano.png" )
	$Sprite/Icon.set_texture(texture)


func operate(player):
	print('using decomposer')
	enabled = !enabled
	
	if enabled:
		$Anim.play("active")
	else:
		$Anim.stop()
		$Anim.play("finished")
	
	$Particles2D.set_emitting(enabled)
#	$Particles2D2.set_emitting(enabled)
	$Light2D.set_visible(enabled)


func _process(delta):
	if controlling and not wearing:
		look_at(get_global_mouse_position())

	if enabled and $DetectionArea.get_overlapping_bodies().size() > 0:
		for i in $DetectionArea.get_overlapping_bodies():
			# do nothing if box is full
			if count >= MAX_COUNT:
				# operate to turn it off
				operate(self)
				return
			
			# only store if the type is the same
			if i.type == 'nano':
				#print('find nano')
				#[TEMP] [FIX] so this thingy will store one object multiple time frmae
				#i.magenet_to_delete(self)
				apply_magnet(i)
				if get_global_position().distance_to(i.get_global_position()) < 60:
					var object_type = i.type
					i.queue_free()
					
#					# spawn entity
#					if object_type in Global.culpits_data:
#						for _i in Global.culpits_data[object_type]["cost"]:
#							count += 1
#					else:
#						count += 1
						
#	if count >= 1 and not in_cd:
#		var e = entity.instance()
#		e.type = "nano"
#		if base.has_method('get_base'):
#			base.get_base().add_child(e)
#		else:
#			base.get_parent().add_child(e)
#		e.set_global_position(get_global_position())
#		e.set_wearing(false)
#		e.velocity = Vector2.DOWN.rotated(get_rotation()).normalized() * 1200
#		e.throwing = true
#		count -= 1
#		$Timer.start()
#		in_cd = true
						
						

func apply_magnet(target):
	
	target.throwing = true
	target.velocity += (get_global_position() - target.get_global_position()).normalized()*15#(target.get_parent().to_local(get_global_position()) - target.get_position()).normalized()*10
	#return get_global_position().distance_to(target.get_global_position())
	#print((target.get_parent().to_local(get_global_position()) - target.get_position()))

func initial_control(body):
	print(name + " is being controller")
	user = body
	controlling = true
	
	if not wearing:
		pass
		#snap_position(body)
	
func stop_control(body):
	user = null
	#body.camera.camera.set_zoom(Vector2(1,1))
	
	controlling = false
	print("stopping " + name + " from controlling")

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
		#$Particles2D2.set_emitting(true)


func _on_VisibilityEnabler2D_screen_exited():
	$Particles2D.set_emitting(false)
	#$Particles2D2.set_emitting(false)


func _on_Timer_timeout():
	in_cd = false # Replace with function body.