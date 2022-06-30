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
	animated_sprite.play("walk")


func check_state_change():
	if controlling:
		persistent_state.velocity = Vector2.ZERO
		change_state.call_func("control")
		
	# change to idle state if velocity reach zero
	elif abs(persistent_state.velocity.length()) < min_move_speed:
		change_state.call_func("idle")


func _physics_process(delta):
	# change animation sprite speed
	animated_sprite.set_speed_scale(persistent_state.velocity.length() / speed)
	
	# change eyes position
	animated_sprite.get_node("Eyes").set_position(lerp(animated_sprite.get_node("Eyes").get_position(), direction * 15, 10 * delta))
	
	# else deal with the velocity
	if direction.length() > 0:
		persistent_state.velocity = lerp(persistent_state.velocity, direction.rotated(persistent_state.camera.get_rotation()).normalized() * speed, acceleration)
	else:
		persistent_state.velocity = lerp(persistent_state.velocity, Vector2.ZERO, friction)
	
	direction = Vector2.ZERO
	persistent_state.move_and_slide(persistent_state.velocity)
	
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

