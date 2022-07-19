extends Culpit


func initial_control(body):
	print(name + " is being controller")
	
	if not wearing:
		operate(body)


func stop_control(body):
	print("stopping " + name + " from controlling")


func operate(player):
	# currently only print when player is holding nano
	if player.consume_storage_object("weed"):
		
		# spawn entity
		var e = entity.instance()

		e.type = Global.entity_data["weed"]["recycled"]
		base.add_child(e)
		
		e.set_global_position(get_global_position())
		e.set_wearing(false)
		e.velocity = Vector2.DOWN.rotated(get_rotation()).normalized() * 1000
		e.throwing = true
