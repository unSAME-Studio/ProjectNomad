extends Culpit

export var preopen = false
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
	if preopen:
		operate(null)


func _process(delta):
	if light2d.is_enabled():
		$Sprite.rotate(rotate_speed * delta)


func operate(player):
	light2d.set_enabled(!light2d.is_enabled())


func powered():
	if not powered:
		powered = true
		
		light2d.set_texture_scale(4)
		rotate_speed = 3
		
		#var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
		#tween.tween_property(light2d, "texture_scale", 4, 0.2)


func unpowered():
	if powered:
		powered = false
		
		light2d.set_texture_scale(2)
		rotate_speed = 1
		
		#var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
		#tween.tween_property(light2d, "texture_scale", 2, 0.2)
