extends State

class_name IdleState


func get_class(): 
	return "IdleState"


func _ready():
	if persistent_state.camera:
		persistent_state.camera.align_camera()
	animated_sprite.play("idle")


func _physics_process(_delta):
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
	if persistent_state.selected_object:
		change_state.call_func("control")
