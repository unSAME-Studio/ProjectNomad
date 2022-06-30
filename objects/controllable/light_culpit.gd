extends Culpit


func _ready():
	._ready()
	
	var l = Light2D.new()
	l.set_texture(load("res://arts/light.png"))
	l.set_energy(0.7)
	l.set_shadow_enabled(true)
	l.set_shadow_filter(Light2D.SHADOW_FILTER_PCF3)
	l.set_shadow_smooth(25.1)
	add_child(l)


func initial_control(body):
	print(name + " is being controller")


func stop_control(body):
	print("stopping " + name + " from controlling")
