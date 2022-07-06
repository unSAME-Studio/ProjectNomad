# Code by https://kidscancode.org/godot_recipes/2d/topdown_movement/

extends KinematicBody2D

var controllables = {}
var controlling = true
var base = null
var selected_object = null
var culpit = null

# An enum allows us to keep track of valid states.
# With a variable that keeps track of the current state, we don't need to add more booleans.
class_name PersistentState
var state
var state_factory

var last_state	#temp print var
var building_mode = false
var build_points = []
var build_point_flag = true
var velocity = Vector2.ZERO
var onboard = false

var health = 100.0
var storage = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
}
onready var storage_ui = $CanvasLayer/Control/VBoxContainer/StorageBox.get_children()

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
		$CanvasLayer/Control/VBoxContainer2/BuildMenu.set_visible(not $CanvasLayer/Control/VBoxContainer2/BuildMenu.is_visible())
	
	if Input.is_action_just_pressed("control"):
		state.interact()


func _process(delta):
	if last_state != state.get_class():
		last_state = state.get_class()
		print(last_state)
#	if build_point_flag:
#		update_build_points()
#		build_point_flag == false
	
	# update health
	$CanvasLayer/Control/VBoxContainer/HBoxContainer2/HealthBar.set_value(health)
	
	# find the cloest controllables
	if controllables.size() > 0:
		selected_object = controllables.values()[0]
		for i in controllables.values():
			if i.get_global_position().distance_to(get_global_position()) < selected_object.get_global_position().distance_to(get_global_position()):
				selected_object = i
		
	else:
		selected_object = null
	
	if last_state != "ControlState":
		# set hint text 
		if selected_object:
			var target_pos = selected_object.get_global_transform_with_canvas().get_origin() - $CanvasLayer/Control/ControlHint.get_size() / 2
			target_pos = Vector2(clamp(target_pos.x, 0, get_viewport_rect().size.x - $CanvasLayer/Control/ControlHint.get_size().x), clamp(target_pos.y, 0, get_viewport_rect().size.y - $CanvasLayer/Control/ControlHint.get_size().y))
			$CanvasLayer/Control/ControlHint.set_position($CanvasLayer/Control/ControlHint.get_position().linear_interpolate(target_pos, 20 * delta))
		
			$CanvasLayer/Control/ControlHint/HBoxContainer/Label.set_text(selected_object.get_hint_text())
				
			$CanvasLayer/Control/ControlHint.show()
			
		else:
			$CanvasLayer/Control/ControlHint.hide()


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


# entering building mode
# if player in control then they can't
# else entering stop other building
func enter_building_mode() -> bool:
	if not building_mode and state.get_class() != "ControlState":
		building_mode = true
		build_point_flag = true
		return true
	
	return false


func end_building_mode() -> bool:
	if building_mode:
		building_mode = false
		return true
	
	return false


func set_prebuild_hint(text, prebuild):
	if text == "":
		$CanvasLayer/Control/PrebuildHint.prebuild = null
		$CanvasLayer/Control/PrebuildHint.hide()
	else:
		$CanvasLayer/Control/PrebuildHint.prebuild = prebuild
		$CanvasLayer/Control/PrebuildHint.set_text(text)
		$CanvasLayer/Control/PrebuildHint.show()


func update_build_points():
	if base and base.has_method('get_build_points'):
		build_points = base.get_build_points()


func get_build_points(type):
	if build_point_flag:
		update_build_points()
	var out_points = []
	for i in build_points:
		if i.type == type:
			if i.active == true:
				out_points.append(i)
	return out_points


# check if player is in the air (by detecting base)
func is_in_air():
	#print("in air: " + String(base == null))
	
	return false
	
	return base == null


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


# storage find space
func find_storage_space():
	for i in range(0, 5):
		if storage[i] == null:
			return i
	
	return null


func attach_object(type):
	var p
	# check if it's a entity or a culpits
	if not type in ["nano"]:
		p = load("res://objects/culpits/Culpit.tscn").instance()
	else:
		p = load("res://objects/entities/Entity.tscn").instance()
	
	$WearSlot.add_child(p)
	
