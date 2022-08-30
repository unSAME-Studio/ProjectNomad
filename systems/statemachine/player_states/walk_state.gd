extends State

class_name WalkState

export var speed = 200
export var friction = 0.1
export var acceleration = 0.3

export var air_speed = 200
export var air_friction = 0.001
export var air_acceleration = 0.25

var min_move_speed = 0.005

var direction = Vector2.ZERO

var controlling = false
var last_input = Vector2.ZERO



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
	#animated_sprite.get_node("Eyes").set_position(lerp(animated_sprite.get_node("Eyes").get_position(), direction * 15, 10 * delta))
	animated_sprite.get_node("Eyes").set_rotation(lerp_angle(animated_sprite.get_node("Eyes").get_rotation(), last_input.angle() - PI/2, 10 * delta))
	
	# else deal with the velocity in air
	#eizi: using acceleration simulation
	if persistent_state.is_in_air():
		persistent_state.get_node('testParticle').set_emitting(true)
		if direction.length() > 0:
			persistent_state.velocity += direction.rotated(persistent_state.camera._get_rotation()).normalized() * 5
			 #lerp(persistent_state.move_velocity, direction.rotated(persistent_state.camera.get_rotation()).normalized() * air_speed, air_acceleration)

		#else:
			#persistent_state.move_velocity = lerp(persistent_state.move_velocity, Vector2.ZERO, air_friction)
#		if persistent_state.velocity > speed:
#			pass
		#print(persistent_state.velocity.normalized()*(air_friction*(int(persistent_state.velocity.length()*10))))
		
		persistent_state.velocity -= persistent_state.velocity.normalized()*(air_friction*(persistent_state.velocity.length()*10))#lerp(persistent_state.velocity, Vector2.ZERO, air_friction)
		
	# or for on the floor
	else:
		persistent_state.get_node('testParticle').set_emitting(false)
		if abs(persistent_state.slide_velocity.x) > 5 or abs(persistent_state.slide_velocity.y) > 5:
			persistent_state.slide_velocity = lerp(persistent_state.slide_velocity, Vector2.ZERO, 0.33)
		else:
			persistent_state.slide_velocity = Vector2.ZERO
		if direction.length() > 0:
			persistent_state.velocity = lerp(persistent_state.velocity, direction.rotated(persistent_state.camera._get_rotation()).normalized() * speed, acceleration)
		else:
			persistent_state.velocity = lerp(persistent_state.velocity, Vector2.ZERO, friction)
			
	#camera movement inheritence
	
	persistent_state.camera.rotation_changed_flag = persistent_state.input_moving
	if direction.length() > 0:
		direction.x = clamp(direction.x,-1,1)
		direction.y = clamp(direction.y,-1,1)
		if last_input != direction:
			last_input = direction
			persistent_state.camera.rotation_changed_flag = false
		
	persistent_state.input_moving = false
		

	direction = Vector2.ZERO
	
	#print(persistent_state.move_velocity)
	#print(persistent_state.slide_velocity)
	#persistent_state.velocity = persistent_state.slide_velocity + persistent_state.move_velocity
	#print(persistent_state.move_velocity)
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
	if persistent_state.selected_object:
		controlling = true

