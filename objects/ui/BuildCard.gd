extends TextureButton

export(String) var build_type = "wheel"

var prebuild = preload("res://objects/buildings/Prebuild.tscn")


func _ready():
	set_normal_texture(load(Global.culpits_data[build_type]["card"]))
	set_pressed_texture(load(Global.culpits_data[build_type]["card"]))
	set_hover_texture(load(Global.culpits_data[build_type]["card"]))


func _on_BuildCard_mouse_entered():
	set_scale(Vector2(1.1, 1.1))
	set_position(Vector2(get_position().x, -20))


func _on_BuildCard_mouse_exited():
	set_scale(Vector2(1, 1))
	set_position(Vector2(get_position().x, 0))


func _on_BuildCard_pressed():
	set_disabled(true)
	set_modulate(Color("7d737373"))
	
	var p = prebuild.instance()
	p.card = self
	p.type = build_type
	Global.player.get_parent().add_child(p)
	
