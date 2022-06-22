extends State

class_name IdleState


func _ready():
	#animated_sprite.play("idle")
	pass


func move_up():
	change_state.call_func("walk")


func move_down():
	change_state.call_func("walk")


func move_left():
	change_state.call_func("walk")


func move_right():
	change_state.call_func("walk")


func interact():
	if persistent_state.selected_culpit:
		change_state.call_func("control")
