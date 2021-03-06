extends Culpit


var light2d
var rotate_speed = 1


func _ready():
	light2d = Light2D.new()
	light2d.set_texture(load("res://arts/light.png"))
	light2d.set_texture_scale(2)
	light2d.set_energy(1)
	light2d.set_mode(Light2D.MODE_MIX)
	light2d.set_shadow_enabled(true)
	light2d.set_shadow_filter(Light2D.SHADOW_FILTER_PCF3)
	light2d.set_shadow_smooth(25.1)
	add_child(light2d)


func _process(delta):
	if light2d.is_enabled():
		$Sprite.rotate(rotate_speed * delta)


func operate(player):
	light2d.set_enabled(!light2d.is_enabled())


func powered():
	light2d.set_texture_scale(4)
	rotate_speed = 2


func unpowered():
	light2d.set_texture_scale(2)
	rotate_speed = 1
