extends KinematicBody2D


func _process(delta):
	var collided = move_and_collide(Vector2.RIGHT.rotated(get_rotation()), true)
	if collided:
		print(collided.get_collider().name)
		queue_free()
