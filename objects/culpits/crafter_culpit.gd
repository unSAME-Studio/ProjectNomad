extends Culpit


func initial_control(body):
	print(name + " is being controller")
	
	if not wearing:
		operate(body)


func stop_control(body):
	print("stopping " + name + " from controlling")


func operate(player):
	# currently only print when player is holding nano
	var result = player.find_slot_by_type("nano")
	if result != null:
		
		# if holding it also remove it
		if result == player.wearing:
			if player.detach_object():
				player.get_node("WearSlot").get_child(0).queue_free()
		else:
			player.remove_storage_object(result)
		
		# spawn entity
		var e = entity.instance()

		e.type = Global.culpits_data.keys()[randi() % Global.culpits_data.size()]
		base.add_child(e)
		
		e.set_global_position(get_global_position())
		e.set_wearing(false)
		e.velocity = Vector2.DOWN.rotated(get_rotation()).normalized() * 1000
		e.throwing = true
