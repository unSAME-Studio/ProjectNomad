extends KinematicBody2D

var explosion = preload("res://objects/VFX/Explosion.tscn")

var parent
var speed = 5
var damage = 6

func _process(delta):
	var collided = move_and_collide(speed * Vector2.RIGHT.rotated(get_rotation()), true)
	if collided:
		print(collided.get_collider().name)
		
		# ignore parent
		if collided.get_collider() == parent:
			return
		
		# send message to the damage component
		if collided.get_collider().has_node("DamageComponent"):
			collided.get_collider().get_node("DamageComponent").damage(parent.user, damage)
		
		# make particles
		var e = explosion.instance()
		e.set_global_position(get_global_position())
		get_parent().add_child(e)
		
		queue_free()


func _on_Timer_timeout():
	queue_free()
