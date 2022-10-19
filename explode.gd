extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var user
var damage = 9
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fire")
	



#func _on_Area2D_body_entered(body):
#	if not body.get_collision_layer_bit(6):
#		if body.has_node("DamageComponent"):
#			print('boomed')
#			body.get_node("DamageComponent").damage(user, damage)
#	elif body.get_class() == 'RigidBody2D':
#		body.apply_impulse(Vector2.ZERO,get_global_position().direction_to(body.get_global_position()) * 100)
#	elif 'throwing' in body:
#		body.throwing = true
#		body.velocity += get_global_position().direction_to(body.get_global_position()) * 100#(target.get_parent().to_local(get_global_position()) - target.get_position()).normalized()*10




func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_Timer_timeout():

	$Area2D.set_position(Vector2.ZERO)
	if $Area2D.get_overlapping_bodies().size() > 0:
		for body in $Area2D.get_overlapping_bodies():
			if not body.get_collision_layer_bit(6):
				if body.has_node("DamageComponent"):
					#print('boomed')
					#print(body)
					body.get_node("DamageComponent").damage(user, damage)
			elif body.get_class() == 'RigidBody2D':
				body.apply_impulse(Vector2.ZERO,get_global_position().direction_to(body.get_global_position()) * 100)
			elif 'throwing' in body:
				body.throwing = true
				body.velocity += get_global_position().direction_to(body.get_global_position()) * 600
