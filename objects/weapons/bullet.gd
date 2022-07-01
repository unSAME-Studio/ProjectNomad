extends KinematicBody2D


var speed = 5


func _process(delta):
	var collided = move_and_collide(speed * Vector2.RIGHT.rotated(get_rotation()), true)
	if collided:
		print(collided.get_collider().name)
		queue_free()
