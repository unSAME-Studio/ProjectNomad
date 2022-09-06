extends Culpit

export var preopen = false

var enabled = false

func _ready():
	pass



func _process(delta):
	pass


func operate(player):
	enabled = !enabled
	if enabled:
		get_tree().get_current_scene().get_node("Node2D/CanvasModulate").color = Color(0.5,0.5,0.5)
	else:
		get_tree().get_current_scene().get_node("Node2D/CanvasModulate").color = Color(0.12,0.12,0.12)


