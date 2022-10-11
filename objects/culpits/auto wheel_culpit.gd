extends Culpit


var running = false
var targeting = false
var on_cd = false


func _ready():
	if base:
		operate(null)


func _process(delta):
	if running and base:
		if base.has_method("handle_movement"):
			var heading = base.to_local(Global.player.get_global_position())
			
			if heading.length() < 3000:
				base.operate()
			
			if not targeting:
				if base.has_method('add_target'):
					targeting = base.add_target(Global.player)
			
			heading.x = clamp(heading.x, -1, 1)
			heading.y = clamp(heading.y, -1, 1)
			
			base.handle_movement(heading)
			
			if heading.x > 0:
				$Sprite.rotate(delta * 4)
			
			if heading.x < 0:
				$Sprite.rotate(-delta * 4)


func operate(player):
	running = !running
	if player != null and player.get("controlling"):
		base.controlling = running


func destroy():
	running = false
	base.controlling = false
	if base.has_method('add_target'):
		base.handle_movement(Vector2.ZERO)
		base.remove_target(Global.player)
		targeting = false



func _on_Timer_timeout():
	on_cd = false
	
