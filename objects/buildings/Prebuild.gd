extends Area2D

const INT_MAX = 2147483647
const SNAP_THRESHOLD = 30

signal built

var card

var type = ""
var hovering = true
var can_build = true


var base = null
var room
var direction = 0


func _ready():
	$Sprite.set_texture(load("res://arts/culpits/%s.png" % type))
	#var space_state = get_world_2d().direct_space_state


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
	# check if player can build here
	if check_build_condition():
		can_build = true
		set_modulate(Color.white)
	else:
		can_build = false
		set_modulate(Color.red)
	
	# move to mouse when hovering
	if hovering:
		
		# snapping by checking nearby edges
		var x_edge = []
		var y_edge = []
		for i in get_tree().get_nodes_in_group("culpit"):
			x_edge.append(i.get_global_position().x)
			y_edge.append(i.get_global_position().y)
		
		var target_snap = get_global_mouse_position()
		var target_x = find_closest(target_snap.x, x_edge)
		var target_y = find_closest(target_snap.y, y_edge)
		
		if target_x:
			target_snap.x = target_x
		
		if target_y:
			target_snap.y = target_y
		
		set_global_position(get_global_position().linear_interpolate(target_snap, 20 * delta))
		set_rotation(Global.player.camera.get_rotation() + PI / 2 * direction)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed():
			#print(get_global_position().distance_to(Global.player.get_global_position()))
			var result = get_world_2d().get_direct_space_state().intersect_point(position, 6 ,[],32,false,true)
			if (not result.empty()):
				room = result[0].collider
				base = room.get_build()
			# check if in range
				if can_build:
					hovering = false
					finish_build(room)
		
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
