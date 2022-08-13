extends KinematicBody2D

var bullet = preload("res://objects/weapons/bullet.tscn")
var speed = 100
var user = self
var base = null

export var baseMode = false
export var immobile = false

func _ready():
	if baseMode:
		var tempbase = get_world_2d().get_direct_space_state().intersect_point($Position2D.get_global_position(), 1 ,[],2,true,false)
		if not tempbase.empty():
			base = tempbase[0].collider
		else:
			base=get_parent()

func _physics_process(delta):
	if Global.player.get_global_position().distance_to(get_global_position()) <= 3000:
		
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
	if Global.player.get_global_position().distance_to(get_global_position()) <= 3000:
		$AnimationPlayer.play("shoot")
		
		
		var b = bullet.instance()
		b.parent = self
		if baseMode:
			var tempbase = get_world_2d().get_direct_space_state().intersect_point($Position2D.get_global_position(), 1 ,[],2,true,false)
			if not tempbase.empty():
				user = tempbase[0].collider
				base = user
			else:
				user = self
		
		b.set_global_position($Enemy/Position2D.get_global_position())
		b.set_global_rotation($Enemy/Position2D.get_global_rotation())
		get_tree().get_current_scene().get_node("Node2D").add_child(b)


func _on_VisibilityEnabler2D_screen_entered():
	$Timer.start()


func _on_VisibilityEnabler2D_screen_exited():
	$Timer.stop()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shoot":
		$AnimationPlayer.play("idle")
