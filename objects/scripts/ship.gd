extends RigidBody2D

export var speed = 200
#export var friction = 0.01
export var acceleration = 0.1

var velocity = Vector2()
var controlling = false
var captain = null

var leave = false

var steerforce = 1
var forwardforce = 1
var brakeforce = 1

var rooms = []

func _ready():
	#$RigidBody2D/PinJoint2D.connect_bodies(self,$RigidBody2D)
	# [TEMP DELETE]
	#$objects/Wall/CollisionPolygon2D.polygon = $objects/Wall/Polygon2D.polygon
	#$objects/Wall/LightOccluder2D.occluder.set_polygon($objects/Wall/Polygon2D.polygon)
	pass

#input is a Polygon2D instance
func update_polygon(input):
	var in_polygon = []
	var offset = input.get_parent().get_position()#(input.get_global_position() - get_global_position()).rotated(get_global_rotation())
	offset = Vector2(int(round(offset.x)),int(round(offset.y)))

	for i in input.polygon:
		in_polygon.append(i+offset)
	$Basecollision.polygon = Geometry.merge_polygons_2d(in_polygon,$Basecollision.polygon)[0]
	$baseshape/Basecollision2.polygon = $Basecollision.polygon


func handle_movement(direction):
		set_applied_torque(direction.x * 20000)		
		set_applied_force(Vector2(direction.x*50,direction.y * 300).rotated(get_rotation()))
		var currvelocity = get_linear_velocity()
		var currrangular = get_angular_velocity()
		if currvelocity.length() > 300:
			set_linear_velocity(lerp(currvelocity, currvelocity.normalized()*300, 0.05))
		if abs(currrangular) > 0.45:
			set_angular_velocity(lerp(currrangular,0.45, 0.05))
			
		if Input.is_action_pressed("ui_select"):
			set_linear_velocity(lerp(currvelocity, Vector2.ZERO, 0.05))
			set_angular_velocity(lerp(currrangular,0, 0.05))
		#velocity = move_and_slide(velocity)
		
func enable_control(user):
	#sleeping = false
	controlling = true
	captain = user


func disable_control():

	captain = null
	controlling = false
	leave = false
	set_applied_force(Vector2(0,0))
	set_applied_torque(0)		
	

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
	if(controlling):
		var direction = get_input()
		handle_movement(direction)
			
			
func _integrate_forces(state):
	pass
			
		
func get_build_points():
	var points = []
	if not rooms.empty():
		for i in rooms:
			points.append_array(i.get_build_points())
	return points

#func _on_baseshape_body_entered(body):
#	if(body.name == 'Player' and body.onboard == false):
#		body.base = self
#		body.onboard = true
#		leave = true
#		var temppos = body.get_global_position()
#		body.get_parent().remove_child(body)
#		self.add_child(body)
#		body.set_global_position(temppos)
#
#
#func _on_baseshape_body_exited(body):
#	if(body.name == 'Player' and body.get_parent() == self and leave == false):
#		#body.base = null
#		var temppos = body.get_global_position()
#		body.onboard = false
#		self.remove_child(body)
#		self.get_parent().add_child(body)
#		body.set_global_position(temppos)

		
func _o1n_baseshape_body_entered(body):
	if(body.name == 'Player' and body.onboard == false):
		body.onboard = true
		leave = true
		var temppos = body.get_global_position()
		body.get_parent().remove_child(body)
		self.add_child(body)
		body.set_global_position(temppos)
		
		
func _o1n_baseshape_body_exited(body):
	if(body.name == 'Player' and body.get_parent() == self and leave == false):
		var temppos = body.get_global_position()
		body.onboard = false
		self.remove_child(body)
		self.get_parent().add_child(body)
		body.set_global_position(temppos)
