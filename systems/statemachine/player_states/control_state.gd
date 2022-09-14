extends State

class_name ControlState


func get_class(): 
	return "ControlState"


func _ready():
	animated_sprite.play("idle")
	
	persistent_state.velocity = Vector2.ZERO
	
	persistent_state.get_node("CanvasLayer/Control/ControlMode").show()
	
	# connect the player
	persistent_state.culpit = persistent_state.selected_object
	if is_instance_valid(persistent_state.culpit):
		persistent_state.culpit.initial_control(persistent_state)
	# if culpit is action type, disconnect immediately
		if bool(persistent_state.selected_object.action) == true:
			interact()
	# play a machine sound
		persistent_state.get_node("Sounds/Culpit").play()
	else:
		persistent_state.culpit = null


func move_up():
	pass


func move_down():
	pass


func move_left():
	pass


func move_right():
	pass


func interact():
	if is_instance_valid(persistent_state.culpit):
		persistent_state.culpit.stop_control(persistent_state)
	persistent_state.culpit = null
	
	persistent_state.get_node("CanvasLayer/Control/ControlMode").hide()
	
	change_state.call_func("idle")
