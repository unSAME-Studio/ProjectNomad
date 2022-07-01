extends Culpit


var controlling = false


func _process(delta):
	if controlling:
		$Sprite.look_at(get_global_mouse_position())


func _unhandled_input(event):
	if controlling:
		if event is InputEventMouseButton:
			if event.get_button_index() == 1 and event.is_pressed():
				print("FIRE!!!")


func initial_control(body):
	# snap body to predefined point
	body.set_global_position($ControlPos.get_global_position())
	
	#body.camera.camera.set_zoom(Vector2(2,2))
	
	controlling = true
	print(name + " is being controller")


func stop_control(body):
	#body.camera.camera.set_zoom(Vector2(1,1))
	
	controlling = false
	print("stopping " + name + " from controlling")
