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

var point_type = "room"
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
		print(build_points)
	else:
		#var space_state = get_world_2d().direct_space_state
		build_points = Global.player.get_build_points('Wall')
		
	

func check_build_condition(target_mode = false) -> bool:
	if target_mode == false:
		target = null
		hovering = true
		return false
	if target:
		# overlapping check
		if structure:
			for i in structure.get_overlapping_bodies():
				if i.get_collision_layer() in [1, 2]:
					if i.get_collision_layer() == 2:
						if target == null:
							Global.player.set_prebuild_hint("Blocked!", self)
							return false
						elif i != target.room.get_build():
							Global.player.set_prebuild_hint("Blocked!", self)
							return false
		
		Global.player.set_prebuild_hint("", self)
		hovering = false
		return true
	else:
		return false


func _process(delta):
	#check if in build_point range
	if build_points:
		#check if on build point
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
						

		# check if player can build now
		if check_build_condition(point_mode):
			can_build = true
			set_modulate(Color.white)
		else:
			can_build = false
			set_modulate(Color.red)
		if hovering:
			set_global_position(get_global_mouse_position())
			set_rotation(Global.player.camera.get_rotation() + PI / 2 * direction)
		else:
			set_global_position(target.get_global_position())
			set_global_rotation(target.get_global_rotation())
			if structure:
				structure.set_global_rotation(target.get_global_rotation() + structure.snappoint.get_rotation())
				structure.set_position(-structure.snappoint.get_position())#.rotated(3.14159-target.get_rotation()))
		
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
		remove_child(structure)
		base.get_node("rooms").add_child(structure)
		structure.set_global_position(temp_pos)
		structure.set_global_rotation(temp_rot)
		structure.active(base)
		build_points = []
	else:
		if target:
			target.queue_free()
	Global.player.end_building_mode()
	
	card.queue_free()
	queue_free()
