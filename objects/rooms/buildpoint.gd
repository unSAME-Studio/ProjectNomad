extends Position2D


export(String,"utility","room","uweapon","Wall","snap","core") var type = "Snap"
var active = true
var object = null
var room = null
var indi
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate_build():
	active = true
	show()
	
func ready_build():
	indi = Sprite.new()
	indi.set_texture(load("res://arts/VFX/Circle.png"))
	indi.set_scale(Vector2(0.8,0.8))
	add_child(indi)
	pass
	
func end_build():
	indi.queue_free()
	pass

func finish_build():
	active = false
	hide()

