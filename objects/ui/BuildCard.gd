extends TextureButton

export(String) var build_type = "wheel"

var prebuild = preload("res://objects/buildings/Prebuild.tscn")
var structure_prebuild = preload("res://objects/rooms/struc_prebuild.tscn")

var hovering = false
var current_prebuild = null

onready var initial_position = get_position()


var type_color = ["647cb5", "cec35b", "7ab266", "c16868"]


func _ready():
	set_self_modulate(type_color[Global.structure_data[build_type]["type"]])
	
	var card = load("res://arts/cards/C_%s.png" % build_type)
	$TextureRect.set_texture(card)
		
	$Label.set_text(build_type)
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rect_scale", Vector2(1, 1), 0.08)
	tween.parallel().tween_property($TextureRect, "rect_scale", Vector2(1, 1), 0.08)


func _on_BuildCard_mouse_entered():
	hovering = true
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rect_scale", Vector2(1.1, 1.1), 0.08)
	tween.parallel().tween_property($TextureRect, "rect_scale", Vector2(1.2, 1.2), 0.08)


func _on_BuildCard_mouse_exited():
	hovering = false
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rect_scale", Vector2(1, 1), 0.08)
	tween.parallel().tween_property($TextureRect, "rect_scale", Vector2(1, 1), 0.08)


func _on_BuildCard_pressed():
	set_disabled(true)
	set_modulate(Color("7d737373"))
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rect_scale", Vector2(0.9, 0.9), 0.08)
	tween.parallel().tween_property($TextureRect, "rect_scale", Vector2(0.9, 0.9), 0.08)
	tween.tween_property(self, "rect_scale", Vector2(1, 1), 0.08)
	tween.parallel().tween_property($TextureRect, "rect_scale", Vector2(1, 1), 0.08)
	if Global.player.building_mode == false:
		var p
		if 'room' in build_type or 'wall' in build_type:
			p = structure_prebuild.instance()
		else:
			p = prebuild.instance()
			p.is_structure = true
		
		p.card = self
		p.type = build_type
		get_tree().get_current_scene().get_node("Node2D").add_child(p)
		
		current_prebuild = p
	else:
		canceled_build()


func _process(delta):
	#if hovering:
	#	$Label.set_position(get_position().linear_interpolate(get_local_mouse_position(), 20 * delta))
	#else:
	#	$Label.set_position(Vector2(6, 0))
	
	return
	
	# [TEMP] WIP card follow mouse
	if current_prebuild:
		set_position(get_position().linear_interpolate(current_prebuild.get_global_transform_with_canvas().get_origin(), 20 * delta))
	else:
		set_position(initial_position)


func canceled_build():
	current_prebuild = null
	
	set_disabled(false)
	set_modulate(Color.white)
	
	
