extends Culpit


var points_to = Vector2(200, 200)
var light2d


func _ready():
	light2d = Light2D.new()
	light2d.set_texture(load("res://arts/light.png"))
	light2d.set_texture_scale(0.5)
	light2d.set_energy(1)
	light2d.set_mode(Light2D.MODE_MIX)
	light2d.set_shadow_enabled(true)
	light2d.set_shadow_filter(Light2D.SHADOW_FILTER_PCF3)
	light2d.set_shadow_smooth(25.1)
	add_child(light2d)


func _process(delta):
	if points_to:
		#$Sprite.look_at(points_to.get_global_position())
		$Sprite.look_at(points_to)


func operate(player):
	pass
