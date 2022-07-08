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

var base_cooldown = false

var input_moving = false

var health = 100.0
var storage = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
}
onready var storage_ui = $CanvasLayer/Control/VBoxContainer/StorageBox.get_children()
var wearing = null

var move_velocity = Vector2(0,0)
var slide_velocity = Vector2(0,0)
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
	
	if Input.is_action_just_pressed("throw"):
		if detach_object():
			var object = $WearSlot.get_child(0)
			
			object.throw(self)

func get_facing() -> Vector2:
	return get_global_mouse_position() - get_global_position()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed():
			if wearing != null:
				$WearSlot.get_child(0).operate(self)
		
		elif event.get_button_index() == 2 and event.is_pressed():
			if wearing != null and storage[wearing] in Global.culpits_data.keys():
				$WearSlot.get_child(0)._on_moved()


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

func switch_base(base):
	if base == null:
		base = get_tree().get_root()
	reparent(self,base)

func _physics_process(delta):
	#temp sliding
	var temp_base = get_world_2d().get_direct_space_state().intersect_point(get_global_position(), 3 ,[],2,true,false)

	var temp_speed = Vector2(0,0)
	var base_velocity = Vector2(0,0)
	#check base
	if not temp_base.empty():
		temp_base=temp_base[0].collider
		if temp_base.has_method("get_linear_velocity"):
			temp_speed = temp_base.get_linear_velocity()
	else:
		temp_base = null
	#switch base
	if temp_base != base and not base_cooldown:
		switch_base(temp_base)
		if base!=null:
			if base.has_method("get_linear_velocity"):
				base_velocity =  base.get_linear_velocity().rotated(base.get_global_rotation()*1.2)
		velocity = base_velocity + velocity - temp_speed
		
		#print(move_velocity)
		$Basetimer.start()
		base_cooldown = true
		base = temp_base
	#print(base)
	state.update()
	
	if Input.is_action_pressed('up'):
		input_moving = true
		state.move_up()
	
	if Input.is_action_pressed('down'):
		input_moving = true
		state.move_down()
	
	if Input.is_action_pressed('left'):
		input_moving = true
		state.move_left()
	
	if Input.is_action_pressed('right'):
		input_moving = true
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
	
	return base == null


# -----------------
# add cards
# -----------------
func add_build_card(type):
	# add a random card to player
	var c = build_card.instance()
	c.build_type = type
	$CanvasLayer/Control/VBoxContainer2/BuildMenu/PanelContainer/MarginContainer/HBoxContainer.add_child(c)


# -----------------
# edit culpit ui menu
# -----------------
func edit_culpit(c):
	# if click on different culpit
	if $CanvasLayer/Control/CulpitMenu.culpit != c:
		$CanvasLayer/Control/CulpitMenu.connect_culpit(c)
	
	# else hide
	else:
		$CanvasLayer/Control/CulpitMenu.close()


# -----------------
# storage management
# -----------------
func find_storage_space():
	for i in range(0, 5):
		if storage[i] == null:
			return i
	
	return null

func find_slot_by_type(type):
	for i in range(0, 5):
		if storage[i] == type:
			return i
	
	return null

func add_storage_object(type) -> bool:
	var slot = find_storage_space()
	if slot != null:
		storage[slot] = type
		storage_ui[slot].add_object(type)
		
		return true
	
	return false

func remove_storage_object(slot) -> bool:
	if storage[slot] != null:
		storage[slot] = null
		storage_ui[slot].remove_object()
		
		return true
	
	return false


# -----------------
# player wearing object management
# -----------------
func attach_object(slot):	
	# if already holding item, hide and delete
	if wearing != null:
		hide_object()
	
	# do nothing if this slot have no item
	if storage[slot] == null:
		return
	
	var p
	# check if it's a entity or a culpits
	if storage[slot] in Global.entity_data.keys():
		p = load("res://objects/entities/Entity.tscn").instance()
	else:
		p = load("res://objects/culpits/Culpit.tscn").instance()
		p.script = load("res://objects/culpits/%s_culpit.gd" % storage[slot])
	
	p.set_wearing(true)
	p.type = storage[slot]
	$WearSlot.add_child(p)
	p.initial_control(self)
	
	wearing = slot

func hide_object():
	wearing = null
	if $WearSlot.get_child_count() == 1:
		$WearSlot.get_child(0).queue_free()

func detach_object() -> bool:
	if wearing != null:
		storage[wearing] = null
		storage_ui[wearing].remove_object()
		wearing = null
		
		return true
	
	return false

# https://godotengine.org/qa/9806/reparent-node-at-runtime
# function for reparenting at realtime
func reparent(child: Node, new_parent: Node):
	if new_parent == null:
		new_parent = get_tree().get_current_scene().get_node("Node2D")
	var old_parent = child.get_parent()
	var old_position = child.get_global_position()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	
	child.set_global_position(old_position)


func _on_Basetimer_timeout():
	base_cooldown = false
	pass # Replace with function body.
