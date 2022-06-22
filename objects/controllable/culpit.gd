extends StaticBody2D


var base = null


func _ready():
	base = get_parent().get_parent()


func get_hint_text():
	return "Press E to Steer"


func initial_control(body):
	body.controlling = false
	body.base = base
	
	base.controlling = true
	base.user = body
	
	body.camera.camera.rotating = true
	body.camera.camera.set_zoom(Vector2(2,2))
	
	print(name + " is being controller")


func stop_control(body):
	print("stopping " + name + " from controlling")
	
	base.controlling = false
	base.user = null
	base.leave = false
	
	body.controlling = true
	body.base = null
