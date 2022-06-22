extends TextureButton

enum TYPE {WHEEL, TURRET, AUTO_TURRET, LOCKER}
export(TYPE) var build_type = TYPE.WHEEL

var cards_group = preload("res://objects/ui/BuildCardsGroup.tres")

var last_state = pressed


var icons = {
	TYPE.WHEEL: "res://arts/cards/C_wheel.png",
	TYPE.TURRET: "res://arts/cards/C_turret.png",
	TYPE.AUTO_TURRET: "res://arts/cards/C_auto_turret.png",
	TYPE.LOCKER: "res://arts/cards/C_locker.png",
}


func _ready():
	set_normal_texture(load(icons[build_type]))
	set_pressed_texture(load(icons[build_type]))
	set_hover_texture(load(icons[build_type]))
	
	# blong in one group
	set_button_group(cards_group)


func _process(delta):
	if pressed != last_state:
		last_state = pressed
		
		# set modulate accordingly
		if pressed:
			set_modulate(Color("c39f20"))
		else:
			set_modulate(Color.white)


func _on_BuildCard_mouse_entered():
	set_scale(Vector2(1.1, 1.1))
	set_position(Vector2(get_position().x, -20))


func _on_BuildCard_mouse_exited():
	set_scale(Vector2(1, 1))
	set_position(Vector2(get_position().x, 0))
