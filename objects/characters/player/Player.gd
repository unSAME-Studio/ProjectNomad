# Code by https://kidscancode.org/godot_recipes/2d/topdown_movement/

extends KinematicBody2D

var controllables = {}
var controlling = true
var base = null
var selected_culpit = null
var culpit = null

# An enum allows us to keep track of valid states.
# With a variable that keeps track of the current state, we don't need to add more booleans.
class_name PersistentState
var state
var state_factory

var velocity = Vector2.ZERO
var onboard = false

var camera


func _ready():
	state_factory = StateFactory.new()
	change_state("idle")


func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(funcref(self, "change_state"), $AnimatedSprite, self)
	state.name = "current_state"
	add_child(state)


func _input(event):	
	if Input.is_action_just_pressed("build_menu"):
		$CanvasLayer/Control/VBoxContainer2/BuildMenu.set_visible(!$CanvasLayer/Control/VBoxContainer2/BuildMenu.is_visible())
	
	if Input.is_action_just_pressed("control"):
		state.interact()


func _process(delta):
	# find the cloest controllables
	if controllables.size() > 0:
		selected_culpit = controllables.values()[0]
		for i in controllables.values():
			if i.get_global_position().distance_to(get_global_position()) < selected_culpit.get_global_position().distance_to(get_global_position()):
				selected_culpit = i
		
	else:
		selected_culpit = null
	
	# set hint text 
	if selected_culpit:
		$CanvasLayer/Control/VBoxContainer/Controllable.set_text(selected_culpit.get_hint_text())
		$CanvasLayer/Control/VBoxContainer/Controllable.set_position(selected_culpit.get_global_transform_with_canvas().get_origin())
	else:
		$CanvasLayer/Control/VBoxContainer/Controllable.set_text("")


func _physics_process(delta):
	if Input.is_action_pressed('up'):
		state.move_up()
	
	if Input.is_action_pressed('down'):
		state.move_down()
	
	if Input.is_action_pressed('left'):
		state.move_left()
	
	if Input.is_action_pressed('right'):
		state.move_right()


# add and remove culpit body in the dictionary
func _on_ControllableDetection_body_entered(body):
	controllables[body.name] = body
	
	print(controllables.values())


func _on_ControllableDetection_body_exited(body):
	controllables.erase(body.name)
