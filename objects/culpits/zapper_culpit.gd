extends Culpit


var controlling = false
var shooting = false
var damage = 2
var cd = 5
var explosion = preload("res://objects/VFX/Explosion.tscn")
var speedBuffs =[]

func _process(delta):
	if controlling and not wearing:
		look_at(get_global_mouse_position())

func buff(buff_type,target):
	if buff_type == 'speed':
		if not target in speedBuffs:
			speedBuffs.append(target)
		
func reset_buff():
	speedBuffs = []
	

func operate(player):
	shooting = !shooting
	$RayCast2D.set_enabled(shooting)
	$Line2D.set_visible(shooting)
	if shooting:
		$Timer.start()
	else:
		$Timer.stop()


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


func _on_Timer_timeout():
	if $CooldownComponent.can_fire(cd):
		
		$RayCast2D.cast_to = Vector2(500 + speedBuffs.size()*150,0)
		reset_buff()
		# consume cooldown
		$CooldownComponent.increase_cooldown(cd)
		
		$Anim.play("fire")
		
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
			var p = PoolVector2Array([Vector2.ZERO, $RayCast2D.cast_to])
			$Line2D.set_points(p)
