extends TextureButton

export(String) var build_type = "wheel"

var prebuild = preload("res://objects/buildings/Prebuild.tscn")


func _ready():
	var card = load("res://arts/cards/C_%s.png" % build_type)
	set_normal_texture(card)
	set_pressed_texture(card)
	set_hover_texture(card)


func _on_BuildCard_mouse_entered():
	set_scale(Vector2(1, 1.1))
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
	get_tree().get_current_scene().get_node("Node2D").add_child(p)
	

func canceled_build():
	set_disabled(false)
	set_modulate(Color.white)
