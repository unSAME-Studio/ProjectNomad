extends "res://objects/scripts/ship.gd"

var action = true
var in_range
var door_open = false
var pbase
var poffset
var pRoffset
var Roffset
var base

var roomset = false

func _ready():
	faction = 'armour'
	for i in $rooms/room.get_node('objects').get_children():
		i.set_collision_layer_bit(0, false)
		i.set_collision_layer_bit(3, false)


func _process(delta):
	pass

func _physics_process(delta):
	if(controlling):
		set_global_position(Global.player.get_global_position())
		look_at(get_global_position() + Global.player.get_facing().rotated(1.57))
		
		if Input.is_action_pressed("fire"):
			operate()
	else:
		if pbase:
			set_global_position(pbase.get_global_position()-poffset.rotated(pbase.get_global_rotation()-pRoffset))
			set_global_rotation(pbase.get_global_rotation() - pRoffset + Roffset)
func get_hint_text():
	return 'Assult Armour'


func stop_control(player):
	pass

func reparent(child: Node, new_parent: Node):
	if new_parent == null:
		new_parent = get_tree().get_current_scene().get_node("Node2D")
	var old_parent = child.get_parent()
	var old_position = child.get_global_position()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	
	child.set_global_position(old_position)


func initial_control(body):
	if controlling:
		controlling = false
		for i in $rooms/room.get_node('structures').get_children():
			if "Door" in i.name:
				i.destroy()
		
		var tempbase = get_world_2d().get_direct_space_state().intersect_point(get_global_position(), 1 ,[],2,true,false)
		if not tempbase.empty():
			pbase = tempbase[0].collider
			
			#buildpoint reset
			if 'rooms' in pbase:

				pbase.rooms.append($rooms/room)
				roomset = true
				for i in $rooms/room.get_node('objects').get_children():
					i.set_collision_layer_bit(0, true)
					i.set_collision_layer_bit(3, true)
			
			poffset = pbase.get_global_position()-get_global_position()
			pRoffset = pbase.get_global_rotation()
			Roffset = get_global_rotation()
		else:
			pbase = null

	else:
		controlling = true
		
		#buildpoint reset
		if pbase and roomset:
			pbase.rooms.erase($rooms/room)
			roomset = false
			for i in $rooms/room.get_node('objects').get_children():
				i.set_collision_layer_bit(0, false)
				i.set_collision_layer_bit(3, false)
				
		Global.player.armour = self
		for i in $rooms/room.get_node('structures').get_children():
			if "Door" in i.name:
				i.repair()


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		in_range = body
		body.controllables[name] = self


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		in_range = null
		body.controllables.erase(name)


func _on_destroy():
	destroy()


func destroy():
	if in_range:
		in_range.objects.erase(name)
	queue_free()


func powered():
	pass

func unpowered():
	pass
