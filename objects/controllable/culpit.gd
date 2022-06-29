extends StaticBody2D


export(String) var type = "wheel"
var base = null


func _ready():
	$Sprite.set_texture(load(Global.culpits_data[type]["icon"]))
	
	base = get_parent().get_parent()


func get_hint_text():
	return Global.culpits_data[type]["hint"]


func initial_control(body):
	# snap body to predefined point
	body.set_global_position($ControlPos.get_global_position())
	
	if base.has_method("enable_control"):
		base.enable_control(body)
	
	#body.camera.camera.set_zoom(Vector2(2,2))
	
	print(name + " is being controller")


func stop_control(body):
	print("stopping " + name + " from controlling")
	
	if base.has_method("disable_control"):
		base.disable_control()
	
	#body.camera.camera.set_zoom(Vector2(1,1))
