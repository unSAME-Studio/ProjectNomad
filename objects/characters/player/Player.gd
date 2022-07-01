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

var last_state	#temp print var
var building_mode = false #temp

var velocity = Vector2.ZERO
var onboard = false

var camera

var build_card = preload("res://objects/ui/BuildCard.tscn")


func _ready():
	Global.player = self
	
	# set up state machine
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
		building_mode = !building_mode
		$CanvasLayer/Control/VBoxContainer2/BuildMenu.set_visible(building_mode)
	
	if Input.is_action_just_pressed("control"):
		state.interact()


func _process(delta):
	if last_state != state.get_class():
		last_state = state.get_class()
		print(last_state)
	
	
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
		var target_pos = selected_culpit.get_global_transform_with_canvas().get_origin() - $CanvasLayer/Control/CulpitHint.get_size() / 2
		target_pos = Vector2(clamp(target_pos.x, 0, get_viewport_rect().size.x - $CanvasLayer/Control/CulpitHint.get_size().x), clamp(target_pos.y, 0, get_viewport_rect().size.y - $CanvasLayer/Control/CulpitHint.get_size().y))
		$CanvasLayer/Control/CulpitHint.set_position($CanvasLayer/Control/CulpitHint.get_position().linear_interpolate(target_pos, 20 * delta))
		
		$CanvasLayer/Control/CulpitHint/Label.set_text(selected_culpit.get_hint_text())
	else:
		$CanvasLayer/Control/CulpitHint/Label.set_text("")


func _physics_process(delta):
	state.update()
	
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


func set_prebuild_hint(text, prebuild):
	if text == "":
		$CanvasLayer/Control/PrebuildHint.prebuild = null
		$CanvasLayer/Control/PrebuildHint.hide()
	else:
		$CanvasLayer/Control/PrebuildHint.prebuild = prebuild
		$CanvasLayer/Control/PrebuildHint.set_text(text)
		$CanvasLayer/Control/PrebuildHint.show()


func get_build_points(type):

	if base and base.has_method('get_build_points'):

		return base.get_build_points(type)

# add cards
func add_build_card(type):
	# add a random card to player
	var c = build_card.instance()
	c.build_type = type
	$CanvasLayer/Control/VBoxContainer2/BuildMenu/PanelContainer/MarginContainer/HBoxContainer.add_child(c)


# edit culpit
func edit_culpit(c):
	# if click on different culpit
	if $CanvasLayer/Control/CulpitMenu.culpit != c:
		$CanvasLayer/Control/CulpitMenu.connect_culpit(c)
	
	# else hide
	else:
		$CanvasLayer/Control/CulpitMenu.close()
