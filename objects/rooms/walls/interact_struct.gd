extends StaticBody2D

var action = true
var door_state = false
var in_range
var base



func get_base():
	return base
# Called when the node enters the scene tree for the first time.
func _ready():
	base = get_parent().get_parent().get_base()
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
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

func _on_destroy():
	destroy()

func _on_mouse_entered():
	Global.player.mouse_select_culpit = self

func destroy():
	if in_range:
		in_range.controllables.erase(name)
	queue_free()


func _on_door_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
#		# right click
#		if event.get_button_index() == 2:
#			Global.player.edit_culpit(self)
#
#			get_tree().set_input_as_handled()
		# left click
		if Global.player.mouse_select_culpit == self:
			if event.get_button_index() == 1:
				Global.player.state.interact()
