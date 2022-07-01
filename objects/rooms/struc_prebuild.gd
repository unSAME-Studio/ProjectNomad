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

var point_type = "Room"
var point_mode = false
var build_points = []

var structure
func _ready():
	$Sprite.set_texture(load("res://arts/VFX/Circle.png"))
	if type == 'room':
		#var space_state = get_world_2d().direct_space_state
		build_points = Global.player.get_build_points(point_type)
		structure = load("res://objects/rooms/room.tscn").instance()
		structure.active = false
		add_child(structure)
	else:
		#var space_state = get_world_2d().direct_space_state
		build_points = Global.player.get_build_points('Wall')
		print(build_points)
	

func check_build_condition() -> bool:
	pass
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
	if not build_points.empty():
		for i in build_points:
			var dist = get_global_mouse_position().distance_to(i.get_global_position()) 
			if dist < 500:
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
				if structure:
					
					structure.set_global_rotation(target.get_global_rotation() + structure.snappoint.get_rotation())
					structure.set_position(structure.snappoint.get_position().rotated(3.14159-target.get_rotation()))
		# move to mouse when hovering
		
	else:
		Global.player.set_prebuild_hint("Not avaliable", self)
	point_mode = false


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed():
			#print(get_global_position().distance_to(Global.player.get_global_position()))
			var result = get_world_2d().get_direct_space_state().intersect_point(position, 6 ,[],32,false,true)
			if target:
				if can_build:
					if structure:
						room = target.room
						base = room.get_build()
						target.finish_build()
					finish_build(room)
					
			
		
		# right click cancel
		elif event.get_button_index() == 2 and event.is_pressed():
			card.canceled_build()
			queue_free()
	
	if Input.is_action_just_pressed("rotate"):
		direction = wrapi(direction + 1, 0, 4)
		print("rotate facing %d" % direction)
		


func finish_build(room):
	
	if structure:
		print("add room")
		var temp_pos = structure.get_global_position()
		var temp_rot = structure.get_global_rotation()
		structure.set_position(Vector2.ZERO)
		structure.set_rotation(0)
		remove_child(structure)
		base.get_node("rooms").add_child(structure)
		structure.set_global_position(temp_pos)
		structure.set_global_rotation(temp_rot)
		structure.active(base)
	else:
		if target:
			target.queue_free()
	Global.player.end_building_mode()
	
	card.queue_free()
	queue_free()
