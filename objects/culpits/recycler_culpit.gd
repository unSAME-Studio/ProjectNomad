extends Culpit


func operate(player):
	# currently only print when player is holding something
	if player.wearing != null:
		if player.storage[player.wearing]["type"] in Global.entity_data.keys():
			if Global.entity_data[player.storage[player.wearing]["type"]]["recyclable"]:
				
				# consume the holding entity
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
		
		else:
			# consume the holding culpit
			if player.detach_object():
				var object = player.get_node("WearSlot").get_child(0)
				var object_type = object.type
				var object_data = object.get_data()
				object.queue_free()
				
				# check for additional resources from box
				var additional_nanos = 0
				if object_type == "box" and object_data != null:
					var box_type = object_data["storing"]
					var box_count = object_data["count"]
					
					# check for if additional box contain is a culpit, if so calculate according nanos
					if box_type in Global.culpits_data.keys():
						additional_nanos = Global.culpits_data[box_type]["cost"] * box_count
					else:
						additional_nanos = box_count
				
				# spawn entity
				for _i in range(Global.culpits_data[object_type]["cost"] + additional_nanos):
					var e = entity.instance()
					e.type = "nano"
					base.add_child(e)
					
					e.set_global_position(get_global_position())
					e.set_wearing(false)
					e.velocity = Vector2.DOWN.rotated(get_rotation()).normalized() * 2000
					e.throwing = true
					
					yield(get_tree().create_timer(0.1), "timeout")
