extends StaticBody2D

var action = true
var door_state = false
var in_range
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func get_hint_text():
	return 'Door'

func stop_control(player):
	pass

func initial_control(body):
	if door_state:
		$Anim.play_backwards("door_interact")
		door_state = !door_state

	else:
		$Anim.play("door_interact")
		door_state = !door_state

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		in_range = body
		body.controllables[name] = self


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		in_range = null
		body.controllables.erase(name)

func destroy():
	if in_range:
		in_range.controllables.erase(name)
	queue_free()
