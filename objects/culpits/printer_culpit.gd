extends Culpit


func initial_control(body):
	print(name + " is being controller")
	
	if not wearing:
		operate(body)


func stop_control(body):
	print("stopping " + name + " from controlling")


func operate(player):
	# currently only print when player is holding nano
	if player.consume_storage_object("nano"):
		
		# spawn card
		player.add_build_card(["wall", "room", "door wall"][randi() % 3])
