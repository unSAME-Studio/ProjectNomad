# Code by https://kidscancode.org/godot_recipes/2d/topdown_movement/

extends KinematicBody2D

export var speed = 200
export var friction = 0.01
export var acceleration = 0.1

var controllables = {}
var controlling = true
var base = null
var culpit = null

var velocity = Vector2()
var onboard = false

onready var camera = get_node("Camera2D")


func _input(event):
	if Input.is_action_just_pressed("build_menu"):
		$CanvasLayer/Control/BuildMenu.set_visible(!$CanvasLayer/Control/BuildMenu.is_visible())
	
	if Input.is_action_just_pressed("control"):
		# check if player already controlling something
		if controlling:
			if controllables.size() > 0:
				culpit = controllables.values()[0]
				culpit.initial_control(self)
		else:
			culpit.stop_control(self)
			culpit = null


func _process(delta):
	if controllables.size():
		$"CanvasLayer/Control/VBoxContainer/Controllable".set_text(controllables.values()[0].get_hint_text())
	else:
		$"CanvasLayer/Control/VBoxContainer/Controllable".set_text("")


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
	var direction = get_input()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	if(controlling):
		velocity = move_and_slide(velocity)
	else:
		#position = base.position
		pass


# add and remove culpit body in the dictionary
func _on_ControllableDetection_body_entered(body):
	controllables[body.name] = body
	
	print("Current controllables: %s" % controllables.values())


func _on_ControllableDetection_body_exited(body):
	controllables.erase(body.name)
