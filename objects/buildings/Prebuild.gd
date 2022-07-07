extends Area2D

const INT_MAX = 2147483647
const SNAP_THRESHOLD = 30
const SNAP_RANGE = 200

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

export var point_type = "utility"
var point_mode = false
var build_points = []

func _ready():
	$Sprite.set_texture(load("res://arts/culpits/%s.png" % type))
	#var space_state = get_world_2d().direct_space_state
	update_points()

func update_points():
	var new_build_points = Global.player.get_build_points(point_type)
	for i in build_points:
		i.end_build()
	build_points = new_build_points
	for i in build_points:
		i.ready_build()

# https://godotengine.org/qa/20263/find-the-closest-number-in-array
func find_closest(value, array):

	var best_match = null
	var least_diff = INT_MAX

	for number in array:

		var diff = abs(value - number)
		
		# ignore if diff is bigger than this threshold
		if diff > SNAP_THRESHOLD:
			continue
		
		if diff < least_diff:
			best_match = number
			least_diff = diff

	return best_match


func check_build_condition(target_mode = false) -> bool:
	if target_mode:
		hovering = false
		Global.player.set_prebuild_hint("", self)
		return true
		
	if get_global_position().distance_to(Global.player.get_global_position()) > 300:
		Global.player.set_prebuild_hint("Too far!", self)
		return false
	var on_floor = false
	hovering = true
	# overlapping check
	for i in get_overlapping_bodies():
		#print(i.get_collision_layer())
		if i.get_collision_layer() in [1, 8]:
			#print(i.get_collision_layer())
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

func check_build_point():
	var result = get_world_2d().get_direct_space_state().intersect_point(get_global_mouse_position(), 3 ,[],1024,false,true)
	if (not result.empty()):
		var dist = 1024
		for i in result:
			var object = i.collider
			if object in build_points:
				var temp = get_global_mouse_position().distance_to(object.get_global_position())
				if dist > temp:
					dist = temp
					target = object
		if target:
			return true
	else:
		target = null
		return false
			
#	if build_points:
#		for i in build_points:
#			var dist = get_global_mouse_position().distance_to(i.get_global_position()) 
#			if dist < SNAP_THRESHOLD:
#				if target == i:
#					return true
#				elif target != i:
#					if target == null:
#						target = i
#						return true
#					elif dist < get_global_mouse_position().distance_to(target.get_global_position()):
#						target = i
#						return true

func _process(delta):
	# check if in build_point range
	point_mode = check_build_point()
#	print(point_mode)
#	print(target)
		
	# check if player can build here
	if check_build_condition(point_mode):
		can_build = true
		set_modulate(Color.white)
	else:
		can_build = false
		set_modulate(Color.red)
	
	if hovering:
		var target_snap = get_global_mouse_position()
		
		var result = get_world_2d().get_direct_space_state().intersect_point(position, 6 ,[],32,false,true)
		if not result.empty():
			var parent = result[0].collider.get_build()
			
			# snapping by checking nearby edges
			var x_edge = []
			var y_edge = []
			for i in parent.get_node("objects").get_children():
				if i.get_global_position().distance_to(get_global_mouse_position()) < SNAP_RANGE:
					x_edge.append(i.get_position().x)
					y_edge.append(i.get_position().y)
		
			target_snap = parent.get_local_mouse_position()
				
			var target_x = find_closest(target_snap.x, x_edge)
			var target_y = find_closest(target_snap.y, y_edge)
		
			if target_x != null:
				target_snap.x = target_x
			
			if target_y != null:
				target_snap.y = target_y
			
			target_snap = parent.get_global_position() + target_snap.rotated(parent.get_global_rotation())
		
		set_global_position(get_global_position().linear_interpolate(target_snap, 20 * delta))
		set_rotation(Global.player.camera.get_rotation() + PI / 2 * direction)
	else:
		if target:
			set_global_position(get_global_position().linear_interpolate(target.get_global_position(), 20 * delta))
			set_rotation(target.get_rotation())
	
	point_mode = false


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed():
			# [TEMP] Repeated function please delete
					
			if target:
				if can_build:
					room = target.room
					base = room.get_build()
					finish_build(room)
					for i in build_points:
						i.end_build()
					build_points = []
					target.finish_build()
					
			else:
				var result = get_world_2d().get_direct_space_state().intersect_point(position, 6 ,[],32,false,true)
				if (not result.empty()):
					room = result[0].collider
					base = room.get_build()
					if can_build:
						hovering = false
						finish_build(base)
				else:
					if can_build:
						hovering = false
						finish_build(base)
			
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
	#print("add script" + "res://objects/culpits/%s_culpit.gd" % type)
	
	room.get_node("objects").add_child(c)
	c.set_global_position(get_global_position())
	
	c.set_global_rotation(get_global_rotation())
	
	Global.player.end_building_mode()
	
	card.queue_free()
	queue_free()
