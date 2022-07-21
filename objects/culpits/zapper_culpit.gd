extends Culpit


var controlling = false
var damage = 2

var explosion = preload("res://objects/VFX/Explosion.tscn")


func _process(delta):
	if controlling and not wearing:
		$Sprite.look_at(get_global_mouse_position())


func operate(player):
	controlling = !controlling
	$RayCast2D.set_enabled(controlling)
	$Line2D.set_visible(controlling)
	
	if controlling:
		$Timer.start()
	else:
		$Timer.stop()


func initial_control(body):
	controlling = true
	print(name + " is being controller")
	
	if not wearing:
		snap_position(body)
	


func stop_control(body):
	#body.camera.camera.set_zoom(Vector2(1,1))
	
	controlling = false
	print("stopping " + name + " from controlling")


func _on_Timer_timeout():
	if $RayCast2D.is_colliding():
		
		# snap line2d position
		$Line2D.get_points().set(1, to_local($RayCast2D.get_collision_point()))
		
		# send message to the damage component
		if $RayCast2D.get_collider().has_node("DamageComponent"):
			$RayCast2D.get_collider().get_node("DamageComponent").damage(damage)
		
		# make particles
		var e = explosion.instance()
		get_tree().get_current_scene().get_node("Node2D").add_child(e)
		e.set_global_position($RayCast2D.get_collision_point())
