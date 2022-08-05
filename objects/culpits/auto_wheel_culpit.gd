extends Culpit


var running = true


func _process(delta):
	if running and base:
		
		if base.has_method("handle_movement"):
			var heading = base.to_local(Global.player.get_global_position())
			heading.x = clamp(heading.x, -1, 1)
			heading.y = clamp(heading.y, -1, 1)
			
			base.handle_movement(heading)
			
			if heading.x > 0:
				$Sprite.rotate(delta * 4)
			
			if heading.x < 0:
				$Sprite.rotate(-delta * 4)


func operate(player):
	running = !running



