extends Area2D


export(String,"utility","room","weapon","Wall","snap","core","connector") var type = "Snap"
var active = true
var object = null
var room = null
var indi

func _ready():
	room = find_parent("room")
	room.build_points.append(self)


func activate_build():
	active = true
	show()
	
func ready_build():
	indi = Sprite.new()
	indi.set_texture(load("res://arts/VFX/Circle.png"))
	indi.set_scale(Vector2(0.8,0.8))
	add_child(indi)

	
func end_build():
	indi.queue_free()

func finish_build():
	active = false
	hide()

