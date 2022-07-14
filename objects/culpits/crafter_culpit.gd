extends Culpit


func initial_control(body):
	print(name + " is being controller")
	
	# currently only print when player is holding nano
	var result = body.find_slot_by_type("nano")
	if result != null:
		
		# if holding it also remove it
		if result == body.wearing:
			if body.detach_object():
				body.get_node("WearSlot").get_child(0).queue_free()
		else:
			body.remove_storage_object(result)
		
		# spawn entity
		var e = entity.instance()

		e.type = "light"
		base.add_child(e)
		
		e.set_global_position(get_global_position())
		e.set_wearing(false)
		e.velocity = Vector2.DOWN.rotated(get_rotation()).normalized() * 1000
		e.throwing = true


func stop_control(body):
	print("stopping " + name + " from controlling")
