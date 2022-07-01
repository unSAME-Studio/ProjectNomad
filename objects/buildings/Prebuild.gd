extends Area2D


signal built

var card

var type = ""
var hovering = true
var can_build = true
var lock_point = false

var base = null
var room
var direction = 0

var target = null

export var point_type = "Utility"
var point_mode = false
var build_points = []

func _ready():
	$Sprite.set_texture(load("res://arts/culpits/%s.png" % type))
	#var space_state = get_world_2d().direct_space_state
	build_points = Global.player.get_build_points(point_type)



func check_build_condition() -> bool:
	if get_global_position().distance_to(Global.player.get_global_position()) > 300:
		Global.player.set_prebuild_hint("Too far!", self)
		return false
	
	var on_floor = false
	
	# overlapping check
	for i in get_overlapping_bodies():
		#print(i.get_collision_layer())
		if i.get_collision_layer() in [1, 8]:
			
			Global.player.set_prebuild_hint("Blocked!", self)
			return false
		
		elif on_floor == false and i.get_collision_layer() == 2:
			on_floor = true
			base = i
	
	# floor check
	if not on_floor:
		Global.player.set_prebuild_hint("Not on floor!", self)
		return false
	
	Global.player.set_prebuild_hint("", self)
	return true


func _process(delta):
	#check if in build_point range
	for i in build_points:
		var dist = get_global_mouse_position().distance_to(i.get_global_position()) 
		if dist < 30:
			if target == i:
				point_mode = true
			elif target != i:
				if target == null:
					target = i
					point_mode = true
				elif dist < get_global_mouse_position().distance_to(target.get_global_position()):
					target = i
					point_mode = true
	if not point_mode:
		target = null
		hovering = true
		# check if player can build here
		if check_build_condition():
			can_build = true
			set_modulate(Color.white)
		else:
			can_build = false
			set_modulate(Color.red)
		if hovering:
			set_global_position(get_global_mouse_position())
			set_rotation(Global.player.camera.get_rotation() + PI / 2 * direction)
	else:
		if target:
			hovering = false
			can_build = true
			Global.player.set_prebuild_hint("", self)
			set_modulate(Color.white)
			set_global_position(target.get_global_position())
			set_rotation(target.get_rotation())
	# move to mouse when hovering
	point_mode = false


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed():
			#print(get_global_position().distance_to(Global.player.get_global_position()))
			var result = get_world_2d().get_direct_space_state().intersect_point(position, 6 ,[],32,false,true)
			if (not result.empty()):
				room = result[0].collider
				base = room.get_build()

				if can_build:
					hovering = false
					finish_build(base)
			elif target:
				if can_build:
					room = target.room
					base = room.get_build()
					finish_build(room)
					target.finish_build()
		
		# right click cancel
		elif event.get_button_index() == 2 and event.is_pressed():
			card.canceled_build()
			queue_free()
	
	if Input.is_action_just_pressed("rotate"):
		direction = wrapi(direction + 1, 0, 4)
		print("rotate facing %d" % direction)


func finish_build(room):
	var c = load("res://objects/culpits/Culpit.tscn").instance()
	c.script = load("res://objects/culpits/%s_culpit.gd" % type)
	c.type = type
	print("add script" + "res://objects/culpits/%s_culpit.gd" % type)
	
	room.get_node("objects").add_child(c)
	c.set_global_position(get_global_position())
	
	c.set_global_rotation(get_global_rotation())
	
	Global.player.end_building_mode()
	
	card.queue_free()
	queue_free()
