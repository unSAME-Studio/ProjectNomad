extends Culpit


var controlling = false
var damage = 5
var cd = 5
var explosion = preload("res://objects/VFX/Explosion.tscn")
var last_rot = 0
var enabled = false

func _process(delta):
	if controlling and not wearing:
		look_at(get_global_mouse_position())


func _physics_process(delta):
	if enabled:
		var current_rot = get_global_rotation()
		var difference = abs(rad2deg(current_rot - last_rot))
		
		last_rot = get_global_rotation()
		if difference > 10.0:
			
			# consume cooldown
			#$CooldownComponent.increase_cooldown(cd)
			
			$Anim.play("fire")
			
			# calculate damage base on swing speed
			damage = lerp(1, 10, (clamp(difference, 10, 60)) / 60.0)
			$DetectionArea.scale.y = lerp($DetectionArea.scale.y,1.5,0.05)
			$DetectionArea.scale.x = lerp($DetectionArea.scale.x,1.3,0.05)
			$DetectionArea.set_position(Vector2.ZERO)
			if $DetectionArea.get_overlapping_bodies().size() > 0:
				for i in $DetectionArea.get_overlapping_bodies():
					if i.has_node("DamageComponent"):
						if i.get_node("DamageComponent").damage(user, damage):
						# snap line2d position
							#var p = PoolVector2Array([Vector2.ZERO, to_local($RayCast2D.get_collision_point())])
							#$Line2D.set_points(p)
						
						# send message to the damage component
						#if $RayCast2D.get_collider().has_node("DamageComponent"):
							#$RayCast2D.get_collider().get_node("DamageComponent").damage(user, damage)
						
						# make particles
							var e = explosion.instance()
							get_tree().get_current_scene().get_node("Node2D").add_child(e)
							e.set_global_position($Position2D.get_global_position())
						#else:
						#	$RayCast2D.add_exception($RayCast2D.get_collider())
					elif 'bullet' in i.name:
						i.set_global_rotation($Sprite.get_global_rotation() + deg2rad(-9 + (randi()%18)))
						i.user = user
						i.parent = self
		
						var e = explosion.instance()
						get_tree().get_current_scene().get_node("Node2D").add_child(e)
						e.set_global_position(i.get_global_position())
						e.scale = Vector2(0.5,0.5)
						# deg2rad( 60 +(randi()%5) * 15)
		else:
			$DetectionArea.scale.y = lerp($DetectionArea.scale.y,0.5,0.08)
			$DetectionArea.scale.x = lerp($DetectionArea.scale.x,0.8,0.05)
	#		else:
	#			# reset line2d
	#			var p = PoolVector2Array([Vector2.ZERO, Vector2(70, 0)])
	#			$Line2D.set_points(p)


func operate(player):
	enabled = ! enabled
	if enabled:
		var dmg_tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		dmg_tween.tween_property($DetectionArea, "scale", Vector2(1,0.5), 0.1)
		$DetectionArea.monitoring = true
		#dmg_tween.parallel().tween_property($CanvasLayer/Control/ProgressBar, "modulate", Color("952b2b"), 0.08)
	else:
		var dmg_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		dmg_tween.tween_property($DetectionArea, "scale", Vector2(1,0), 0.1)
		$DetectionArea.monitoring = false
		


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
