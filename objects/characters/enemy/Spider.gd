extends KinematicBody2D

var bullet = preload("res://objects/weapons/bullet.tscn")
var speed = 100
var user = self
var cd = 20
var curr_ar
export var immobile = true


func _ready():
	pass


func _physics_process(delta):
	if Global.player.get_global_position().distance_to(get_global_position()) <= 1000:
		
		$Enemy.look_at(Global.player.get_global_position())
		if not immobile:
			var temp_base = get_world_2d().get_direct_space_state().intersect_point($Position2D.get_global_position(), 1 ,[],2,true,true)
			if temp_base.empty():
				speed = 25
			else:
				speed = 100
			
			if Global.player.get_global_position().distance_to(get_global_position()) >= 500:
				var heading = to_local(Global.player.get_global_position())
				heading.x = clamp(heading.x, -1, 1)
				heading.y = clamp(heading.y, -1, 1)
				move_and_collide(heading * delta * speed, false)


func _on_Timer_timeout():
	if $CooldownComponent.can_fire(cd):
		if Global.player.get_global_position().distance_to(get_global_position()) <= 1000:
			if Global.player.armour != null:
				if Global.player.armour != curr_ar:
					curr_ar = Global.player.armour 
					for i in Global.player.armour.get_node('rooms/room/structures').get_children():
						$Enemy/RayCast2D.add_exception(i)
			if $Enemy/RayCast2D.is_colliding():

				#print($Enemy/RayCast2D.get_collider().name)
				if "Player" == $Enemy/RayCast2D.get_collider().name or $Enemy/RayCast2D.get_collider() == curr_ar:
					$AnimationPlayer.play("shoot")
					
					var b = bullet.instance()
					b.parent = self
					b.set_global_position($Enemy/Position2D.get_global_position())
					b.set_global_rotation($Enemy/Position2D.get_global_rotation())
					get_tree().get_current_scene().get_node("Node2D").add_child(b)
					
					$CooldownComponent.increase_cooldown(cd)


func _on_VisibilityEnabler2D_screen_entered():
	$Timer.start()


func _on_VisibilityEnabler2D_screen_exited():
	$Timer.stop()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shoot":
		$AnimationPlayer.play("idle")
