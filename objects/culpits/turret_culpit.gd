extends Culpit


var controlling = false

var bullet = preload("res://objects/weapons/bullet.tscn")


func _ready():
	._ready()
	
	var p = Position2D.new()
	add_child(p)
	p.set_name("Position2D")
	p.set_position(Vector2(10, 0))


func _process(delta):
	if controlling and not wearing:
		$Sprite.look_at(get_global_mouse_position())


func operate(player):
	print("FIRE!!!")
	var b = bullet.instance()
	b.parent = self
	b.set_global_position($Position2D.get_global_position())
	b.set_global_rotation($Sprite.get_global_rotation())
	get_tree().get_current_scene().get_node("Node2D").add_child(b)


func initial_control(body):
	controlling = true
	print(name + " is being controller")
	
	if not wearing:
		snap_position(body)


func stop_control(body):
	#body.camera.camera.set_zoom(Vector2(1,1))
	
	controlling = false
	print("stopping " + name + " from controlling")
