extends Culpit


func operate(player):
	# currently only print when player is holding something
	if player.wearing != null:
		if player.storage[player.wearing]["type"] in Global.entity_data.keys():
			if Global.entity_data[player.storage[player.wearing]["type"]]["recyclable"]:
				
				# consume the holding object
				if player.detach_object():
					var object = player.get_node("WearSlot").get_child(0)
					var object_type = object.type
					object.queue_free()
					
					# spawn entity
					var e = entity.instance()

					e.type = Global.entity_data[object_type]["recycled"]
					base.add_child(e)
					
					e.set_global_position(get_global_position())
					e.set_wearing(false)
					e.velocity = Vector2.DOWN.rotated(get_rotation()).normalized() * 1000
					e.throwing = true
