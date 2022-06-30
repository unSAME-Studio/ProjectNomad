extends Culpit


var controlling = false


func _process(delta):
	if controlling:
		if Input.is_action_pressed("left"):
			$Sprite.rotate(delta * 4)
		if Input.is_action_pressed("right"):
			$Sprite.rotate(-delta * 4)


func initial_control(body):
	controlling = true
	
	# snap body to predefined point
	body.set_global_position($ControlPos.get_global_position())
	
	base.enable_control(body)
	
	body.camera.camera.set_zoom(Vector2(2,2))
	
	print(name + " is being controller")


func stop_control(body):
	print("stopping " + name + " from controlling")
	
	base.disable_control()
	
	body.camera.camera.set_zoom(Vector2(1,1))
	
	controlling = false
