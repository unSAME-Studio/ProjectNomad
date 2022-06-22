# Code by https://kidscancode.org/godot_recipes/2d/topdown_movement/

extends RigidBody2D

export var speed = 200
#export var friction = 0.01
export var acceleration = 0.1

var velocity = Vector2()
var controlling = true

var user = null
var leave = false

var steerforce = 1
var forwardforce = 1
var brakeforce = 1

func _ready():
	# [TEMP DELETE]
	$objects/Wall/CollisionPolygon2D.polygon = $objects/Wall/Polygon2D.polygon
	#$objects/Walls/LightOccluder2D.get_occluder_polygon().polygon = $objects/Walls.polygon

func handle_movement(direction):
		set_applied_torque(direction.x * 20000)		
		set_applied_force(Vector2(direction.x*50,direction.y * 300).rotated(get_rotation()))
		var currvelocity = get_linear_velocity()
		var currrangular = get_angular_velocity()
		if currvelocity.length() > 300:
			set_linear_velocity(lerp(currvelocity, currvelocity.normalized()*300, 0.05))
		if abs(currrangular) > 0.5:
			set_angular_velocity(lerp(currrangular,0.5, 0.05))
		#velocity = move_and_slide(velocity)

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input


func _physics_process(delta):
	pass
			
			
func _integrate_forces(state):
	if(controlling):
		var direction = get_input()
		handle_movement(direction)
			
		

func _on_baseshape_body_entered(body):
	if(body.name == 'Player' and body.onboard == false):
		body.onboard = true
		leave = true
		var temppos = body.get_global_position()
		body.get_parent().remove_child(body)
		self.add_child(body)
		body.set_global_position(temppos)
		body.camera.camera.rotating = true
		
		
func _on_baseshape_body_exited(body):
	if(body.name == 'Player' and body.get_parent() == self and leave == false):
		var temppos = body.get_global_position()
		body.onboard = false
		self.remove_child(body)
		self.get_parent().add_child(body)
		body.set_global_position(temppos)
		
