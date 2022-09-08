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

var wall_info = 0

var snapindex = 0
var roomindex = '2'

var structure

func _ready():
	Global.building = self
	$Sprite.set_texture(load("res://arts/structures/S_%s.png" % type))
	if not 'remove' in type:
		if 'room' in type:
			roomindex = type.substr(4)
			point_type = 'room'
			type = 'room'
			#build_points = Global.player.get_build_points(point_type)
			structure = load("res://objects/rooms/room%s.tscn" % roomindex).instance()
			structure.active = false
			add_child(structure)
	else:
		point_type = 'room remove'
	if 'wall' in type:
		point_type = 'wall'
	update_points()

		
func update_points():
	var new_build_points = Global.player.get_build_points(point_type)
	for i in build_points:
		i.end_build()
	build_points = new_build_points
	for i in build_points:
		i.ready_build()

func check_build_condition(target_mode = false) -> bool:
	if target_mode == false:
		#if target:
			#target.set_scale(Vector2(1,1))
		target = null
		hovering = true
		return false
	if target:
		#target.set_scale(Vector2(2,2))
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


func _process(_delta):
	#check if in build_point range
	if build_points:
		#check if on build point, output a buildpoint to target, and set point_mode to true if =\ 
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
			set_global_rotation(target.get_parent().get_global_rotation())
			if structure:
				structure.set_rotation((3.14159 - structure.snappoint[snapindex].get_parent().get_rotation()))
				structure.set_global_position(target.get_global_position()-(structure.snappoint[snapindex].get_global_position()-structure.get_global_position()))
		
				#structure.set_rotation((3.14159 - structure.snappoint[snapindex].get_parent().get_rotation()))
				#structure.set_position((structure.snappoint[snapindex].get_global_position()-structure.get_global_position()).rotated(-structure.snappoint[snapindex].get_parent().get_rotation()))
		
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
						target.finish_build(null,true)
						target.room_bind = structure
						room.linked_rooms.append(weakref(structure))
						structure.snappoint[snapindex].finish_build(null,false)
						#structure.snappoint[snapindex].room_bind = structure
						
					finish_build(room)
					
			
		
		# right click cancel
		elif event.get_button_index() == 2 and event.is_pressed():
			card.canceled_build()
			for i in build_points:
				i.end_build()
			queue_free()
	
	if Input.is_action_just_pressed("rotate"):
		if structure:
			snapindex = (snapindex + 1)%structure.snappoint.size()
		


func finish_build(room):
	if Global.building == self:
		Global.building = null
	if structure:
		print("add room")
		var temp_pos = structure.get_global_position()
		var temp_rot = structure.get_global_rotation()
		remove_child(structure)
		base.get_node("rooms").add_child(structure)
		structure.set_global_position(temp_pos)
		structure.set_global_rotation(temp_rot)
		structure.active(base)
	
	
		
	else:
		if target:
			if target.room_bind:
				target.remove_room()
			elif target.wall:
				if type == 'wall upgrade':
					target.wall.upgrade()
				else:
					target.wall.switch()
					if target.wall.type == 'door wall':
						target.wall.spawn_door()
	for i in build_points:
		i.end_build()
	build_points = []
	Global.player.build_point_flag = true
	Global.player.end_building_mode()
	
	
	card.canceled_build()
	queue_free()
	

