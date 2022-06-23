extends State

class_name IdleState


func get_class(): 
	return "IdleState"


func _ready():
	#animated_sprite.play("idle")
	pass


func _physics_process(delta):
	persistent_state.move_and_slide(persistent_state.velocity)


func move_up():
	change_state.call_func("walk")


func move_down():
	change_state.call_func("walk")


func move_left():
	change_state.call_func("walk")


func move_right():
	change_state.call_func("walk")


func interact():
	print("initialing idle c")
	if persistent_state.selected_culpit:
		change_state.call_func("control")
