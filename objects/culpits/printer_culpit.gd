extends Culpit


func operate(player):
	# currently only print when player is holding nano
	if player.consume_storage_object("nano"):
		
		# spawn card
		player.add_build_card(["wall", "room", "door wall"][randi() % 3])
