extends Position2D


export(String,"Weapon","Room","Utility","Wall","Snap","Core") var type = "Snap"
var active = true
var object = null
var room = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate_build():
	active = true
	show()
	
func ready_build():
	pass

func finish_build():
	active = false
	hide()

