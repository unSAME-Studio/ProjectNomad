extends RigidBody2D

export var size = 3


var faction = 'environment'

func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if get_colliding_bodies().empty():
	#	set_linear_velocity(lerp(get_linear_velocity(), Vector2.ZERO, 0.001))
func _on_destroy():
	size -= 1
	if size > 0:
		for i in range(1 + randi() % 3):
			var p = load("res://objects/enviorments/rocks.tscn").instance()
			p.size = size
			var pos_rand = Vector2(100-randi() % 200,100 -randi() % 200)
			var s_rand = (4+randi() % 3)*0.1
			p.set_global_position(get_global_position() + pos_rand)
			p.get_node('Polygon2D').scale = get_node('Polygon2D').scale* s_rand
			p.get_node('CollisionPolygon2D').scale = p.get_node('Polygon2D').scale
			p.mass = mass*s_rand
			p.rotation_degrees = 180 - randi()%360
			

			
			get_parent().add_child(p)
			p.apply_impulse(-pos_rand, pos_rand)
	queue_free()
			
func destory():
	pass
