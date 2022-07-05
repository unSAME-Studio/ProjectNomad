extends TextureButton

export(String) var build_type = "wheel"

var prebuild = preload("res://objects/buildings/Prebuild.tscn")
var structure_prebuild = preload("res://objects/rooms/struc_prebuild.tscn")

var current_prebuild = null

onready var initial_position = get_position()


var type_color = ["647cb5", "cec35b", "7ab266", "c16868"]


func _ready():
	var card = load("res://arts/cards/C_%s.png" % build_type)
	$TextureRect.set_texture(card)
	
	set_self_modulate(type_color[Global.culpits_data[build_type]["type"]])
	
	$Label.set_text(build_type)


func _on_BuildCard_mouse_entered():
	set_scale(Vector2(1, 1.1))
	set_position(Vector2(get_position().x, -20))
	

func _on_BuildCard_mouse_exited():
	set_scale(Vector2(1, 1))
	set_position(Vector2(get_position().x, 0))


func _on_BuildCard_pressed():
	set_disabled(true)
	set_modulate(Color("7d737373"))
	
	var p
	if build_type in ['room', 'wall']:
		p = structure_prebuild.instance()
	else:
		p = prebuild.instance()
	
	p.card = self
	p.type = build_type
	get_tree().get_current_scene().get_node("Node2D").add_child(p)
	
	current_prebuild = p


func _process(delta):
	return
	
	# [TEMP] WIP card follow mouse
	if current_prebuild:
		set_position(get_global_position().linear_interpolate(current_prebuild.get_global_transform_with_canvas().get_origin(), 20 * delta))
	else:
		set_position(initial_position)


func canceled_build():
	current_prebuild = null
	
	set_disabled(false)
	set_modulate(Color.white)
	
	
