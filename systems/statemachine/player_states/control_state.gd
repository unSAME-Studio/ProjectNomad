extends State

class_name ControlState


func _ready():
	persistent_state.velocity = Vector2.ZERO
	
	# connect the player
	persistent_state.culpit = persistent_state.selected_culpit
	persistent_state.culpit.initial_control(persistent_state)


func move_up():
	pass


func move_down():
	pass


func move_left():
	pass


func move_right():
	pass


func interact():
	persistent_state.culpit.stop_control(persistent_state)
	persistent_state.culpit = null
	
	change_state.call_func("idle")
