extends Culpit


var entity = preload("res://objects/entities/Entity.tscn")


func initial_control(body):
	print(name + " is being controller")
	
	# currently only print when player is holding nano
	if body.wearing != null and body.storage[body.wearing] == "nano":
		# removev
		if body.detach_object():
			body.get_node("WearSlot").get_child(0).queue_free()
			
		body.add_build_card(["wheel", "light", "printer", "locker", "turret"][randi() % 5])


func stop_control(body):
	print("stopping " + name + " from controlling")
