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
		body.add_build_card(["wall", "room", "door wall"][randi() % 3])


func stop_control(body):
	print("stopping " + name + " from controlling")


func operate(player):
	initial_control(player)
