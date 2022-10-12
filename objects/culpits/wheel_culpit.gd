extends Culpit


var controlling = false


func _process(delta):
	if controlling:
		if Input.is_action_pressed("left"):
			$Sprite.rotate(delta * 4)
		if Input.is_action_pressed("right"):
			$Sprite.rotate(-delta * 4)


func initial_control(body):
	user = body
	
	if not wearing:
		snap_position(body)
		
		if base.has_method("enable_control"):
			base.enable_control(body)
			controlling = true
		
		if body.get("camera"):
			body.camera.camera.set_zoom(Vector2(2,2))
	
	print(name + " is being controller")


func stop_control(body):
	if controlling:
		
		print("stopping " + name + " from controlling")
		user = null
		if not wearing:
			if base.has_method("enable_control"):
				base.disable_control()
			
			if body.get("camera"):
				body.camera.camera.set_zoom(Vector2(1,1))
		
		controlling = false
