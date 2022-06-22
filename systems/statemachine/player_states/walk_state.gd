extends State

class_name WalkState

export var speed = 200
export var friction = 0.1
export var acceleration = 0.3
var min_move_speed = 0.005

var direction = Vector2.ZERO

var controlling = false

func get_class(): 
	return "WalkState"


func _ready():
	pass

func check_state_change():
	if controlling:
		persistent_state.velocity = Vector2.ZERO
		change_state.call_func("control")
		
	elif abs(persistent_state.velocity.length()) < min_move_speed:
		change_state.call_func("idle")

func _physics_process(_delta):
	# change to idle state if velocity reach zero
	
	# else deal with the velocity
	if direction.length() > 0:
		persistent_state.velocity = lerp(persistent_state.velocity, direction.normalized() * speed, acceleration)
	else:
		persistent_state.velocity = lerp(persistent_state.velocity, Vector2.ZERO, friction)
	
	direction = Vector2.ZERO
	check_state_change()


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
		controlling = true

