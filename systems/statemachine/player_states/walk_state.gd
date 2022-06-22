extends State

class_name WalkState

export var speed = 200
export var friction = 0.1
export var acceleration = 0.3
var min_move_speed = 0.005

var direction = Vector2.ZERO


func get_class(): 
	return "WalkState"


func _ready():
	pass


func _physics_process(_delta):
	# change to idle state if velocity reach zero
	if abs(persistent_state.velocity.length()) < min_move_speed:
		 change_state.call_func("idle")
	
	# else deal with the velocity
	if direction.length() > 0:
		persistent_state.velocity = lerp(persistent_state.velocity, direction.normalized() * speed, acceleration)
	else:
		persistent_state.velocity = lerp(persistent_state.velocity, Vector2.ZERO, friction)
	
	direction = Vector2.ZERO


func move_up():
	direction.y -= 1


func move_down():
	direction.y += 1


func move_left():
	direction.x -= 1


func move_right():
	direction.x += 1


func interact():
	if persistent_state.selected_culpit:
		change_state.call_func("control")
