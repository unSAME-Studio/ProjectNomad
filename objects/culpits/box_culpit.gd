extends Culpit

const RANGE = 70

var storing = null
var count = 0


func _ready():
	._ready()
	
	var area2d = Area2D.new()
	add_child(area2d)
	
	var collision = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	collision.set_shape(circle.set_radius(RANGE))
	area2d.add_child(collision)


func _process(delta):
	pass


func operate(player):
	pass


func initial_control(body):
	print("HOLDING A BOX")


func stop_control(body):
	print("stopping " + type + " from controlling")
