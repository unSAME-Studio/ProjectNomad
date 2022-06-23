extends StaticBody2D


var base = null


func _ready():
	base = get_parent().get_parent()


func get_hint_text():
	return "Press E to Steer"


func initial_control(body):
	body.set_global_position($ControlPos.get_global_position())
	base.enable_control(body)
	body.camera.camera.set_zoom(Vector2(2,2))
	
	print(name + " is being controller")


func stop_control(body):
	print("stopping " + name + " from controlling")
	
	base.disable_control()
	body.camera.camera.set_zoom(Vector2(1,1))
