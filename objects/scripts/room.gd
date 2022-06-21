# Code by https://kidscancode.org/godot_recipes/2d/topdown_movement/

extends KinematicBody2D

export var speed = 200
export var friction = 0.01
export var acceleration = 0.1

var velocity = Vector2()
var controlling = false
var user = null
var leave = false


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
		
		rotation_degrees += direction.x
		#var direction_vector = Vector2.UP.rotated(deg2rad(rotation_degrees)).normalized()
		direction = Vector2(0,direction.y).rotated(deg2rad(rotation_degrees)).normalized()
		if direction.length() > 0:
			velocity = lerp(velocity, direction * speed, acceleration)
		else:
			velocity = lerp(velocity, Vector2.ZERO, friction)
		
		velocity = move_and_slide(velocity)
		
		if Input.is_action_pressed("ui_cancel"):
			controlling = false
			if(user):
				user.controlling = true
				user.base = null
			user = null
			leave = false
			


func _on_baseshape_body_entered(body):
	if(body.name == 'Player' and body.onboard == false):
		body.onboard = true
		leave = true
		var temppos = body.get_global_position()
		body.get_parent().remove_child(body)
		self.add_child(body)
		body.set_global_position(temppos)
		body.camera.rotating = true
		
		
func _on_baseshape_body_exited(body):
	if(body.name == 'Player' and body.get_parent() == self and leave == false):
		var temppos = body.get_global_position()
		body.onboard = false
		self.remove_child(body)
		self.get_parent().add_child(body)
		body.set_global_position(temppos)
		
