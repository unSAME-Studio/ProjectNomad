extends RigidBody2D

class_name Base

export (String) var type

var velocity = Vector2()

var rooms = []

func _ready():
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
	pass
		
func enable_control(user):
	pass


func disable_control():
	pass
	

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
	pass
			

func get_build():
	return self

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

		
