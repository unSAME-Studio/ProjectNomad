extends Culpit


var controlling = false

var bullet = preload("res://objects/weapons/bullet.tscn")

var cooldown_comp = preload("res://systems/CooldownComponent.tscn")
var cooldown


func _ready():
	var p = Position2D.new()
	$Sprite.add_child(p)
	p.set_name("Position2D")
	p.set_position(Vector2(10, 0))
	
	cooldown = cooldown_comp.instance()
	add_child(cooldown)
	cooldown.set_name("CooldownComponent")
	cooldown.speed = 10


func _process(delta):
	if controlling and not wearing:
		$Sprite.look_at(get_global_mouse_position())


func operate(player):
	if cooldown.can_fire(10):
		print("FIRE!!!")
		var b = bullet.instance()
		b.parent = self
		b.set_global_position($Sprite/Position2D.get_global_position())
		b.set_global_rotation($Sprite.get_global_rotation())
		get_tree().get_current_scene().get_node("Node2D").add_child(b)
		
		cooldown.increase_cooldown(10)


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
