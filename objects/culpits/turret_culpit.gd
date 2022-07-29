extends Culpit


var controlling = false

var bullet = preload("res://objects/weapons/bullet.tscn")

var damage = 6
var projectile_speed = 5
var cd = 0.25


func _ready():
	var p = Position2D.new()
	$Sprite.add_child(p)
	p.set_name("Position2D")
	p.set_position(Vector2(10, 0))


func _process(delta):
	if controlling and not wearing:
		$Sprite.look_at(get_global_mouse_position())


func operate(player):
	print("FIRE!!!")
	var b = bullet.instance()
	if slotted:
		b.damage = damage + slotted.damage_buff
		b.speed = projectile_speed*slotted.speed_buff
	b.parent = self
	b.scale = scale
	b.set_global_position($Sprite/Position2D.get_global_position())
	b.set_global_rotation($Sprite.get_global_rotation())
	get_tree().get_current_scene().get_node("Node2D").add_child(b)


func initial_control(body):
	controlling = true
	user = body
	print(name + " is being controller")
	
	if not wearing:
		snap_position(body)


func stop_control(_body):
	user = null
	#body.camera.camera.set_zoom(Vector2(1,1))
	
	controlling = false
	print("stopping " + name + " from controlling")
