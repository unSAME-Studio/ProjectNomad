extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var base = null


# Called when the node enters the scene tree for the first time.
func _ready():
	base = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if(body.name == 'Player'):
		body.controlling = false
		base.controlling = true
		base.user = body
		body.base = base
