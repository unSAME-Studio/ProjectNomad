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
		player.add_build_card(["wall", "room", "door wall"][randi() % 3])
