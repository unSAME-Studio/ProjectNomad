extends Culpit


var controlling = false

var bullet = preload("res://objects/weapons/bullet.tscn")


func _process(delta):
	if controlling and not wearing:
		$Sprite.look_at(get_global_mouse_position())


func operate(player):
	print("FIRE!!!")
	var b = bullet.instance()
	b.parent = self
	b.set_global_position(get_global_position())
	b.set_global_rotation($Sprite.get_global_rotation())
	get_tree().get_current_scene().get_node("Node2D").add_child(b)


func initial_control(body):
	snap_position(body)
	
	#body.camera.camera.set_zoom(Vector2(2,2))
	
	controlling = true
	print(name + " is being controller")


func stop_control(body):
	#body.camera.camera.set_zoom(Vector2(1,1))
	
	controlling = false
	print("stopping " + name + " from controlling")
