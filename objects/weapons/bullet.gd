extends KinematicBody2D

var explosion = preload("res://objects/VFX/Explosion.tscn")

var parent
onready var user = parent.user
var speed = 15
var original_speed = speed

var damage = 6
var collided = null

export var mounted = true


func _physics_process(delta):
	move_and_collide(speed * Vector2.RIGHT.rotated(get_rotation()))
	if collided:
		
#		# ignore parent (turret
#		if collided.get_collider() == parent:
#			return
#
#		# send message to the damage component
#		if collided.get_collider().has_node("DamageComponent"):
#			collided.get_collider().get_node("DamageComponent").damage(user, damage)

		# make particles
		var e = explosion.instance()
		e.scale = scale
		e.modulate = modulate
		e.set_global_position(get_global_position())
		get_parent().add_child(e)
		
		queue_free()


func _on_Timer_timeout():
	queue_free()


func _on_fuse_area_entered(area):
	pass


func _on_fuse_body_entered(body):
	if not body.get_collision_layer_bit(6):
		if body != parent and body != user:
			if body.has_node("DamageComponent"):
				if mounted:
					if body.get_node("DamageComponent").damage(user, damage):
						collided = true
				else:
					body.get_node("DamageComponent").damage(user, damage)
					collided = true


func change_speed(new_speed_percentage):
	speed = original_speed * new_speed_percentage

