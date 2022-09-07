extends Culpit


var controlling = false
var damage = 5
var cd = 5
var explosion = preload("res://objects/VFX/Explosion.tscn")
var last_rot = 0


func _process(delta):
	if controlling and not wearing:
		look_at(get_global_mouse_position())


func _physics_process(delta):
	var current_rot = get_global_rotation()
	var difference = abs(rad2deg(current_rot - last_rot))
	
	last_rot = get_global_rotation()

	if difference > 10.0:
		
		# consume cooldown
		#$CooldownComponent.increase_cooldown(cd)
		
		$Anim.play("fire")
		
		# calculate damage base on swing speed
		damage = lerp(1, 10, (clamp(difference, 10, 60)) / 60.0)
		print("DRILL %s" % damage)
		
		if $RayCast2D.is_colliding():
			if $RayCast2D.get_collider().has_node("DamageComponent"):
				if $RayCast2D.get_collider().get_node("DamageComponent").damage(user, damage):
					# snap line2d position
					var p = PoolVector2Array([Vector2.ZERO, to_local($RayCast2D.get_collision_point())])
					$Line2D.set_points(p)
					
					# send message to the damage component
					if $RayCast2D.get_collider().has_node("DamageComponent"):
						$RayCast2D.get_collider().get_node("DamageComponent").damage(user, damage)
					
					# make particles
					var e = explosion.instance()
					get_tree().get_current_scene().get_node("Node2D").add_child(e)
					e.set_global_position($RayCast2D.get_collision_point())
				else:
					$RayCast2D.add_exception($RayCast2D.get_collider())
		else:
			# reset line2d
			var p = PoolVector2Array([Vector2.ZERO, Vector2(70, 0)])
			$Line2D.set_points(p)


func operate(player):
	pass


func initial_control(body):
	print(name + " is being controller")
	user = body
	controlling = true
	
	if not wearing:
		pass
		#snap_position(body)
	


func stop_control(body):
	user = null
	#body.camera.camera.set_zoom(Vector2(1,1))
	$RayCast2D.clear_exceptions()
	controlling = false
	print("stopping " + name + " from controlling")
