extends KinematicBody2D

class_name Entity

const SNAP_RANGE = 300

export(String) var type = "nano"
var action = true
var wearing = false


func set_wearing(value):
	wearing = value
	# if player is weearing this, it shouldn't be interactable or collision
	if wearing:
		set_collision_layer_bit(6, false)
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(3, false)
		set_collision_mask_bit(6, false)
	else:
		set_collision_layer_bit(6, true)
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(3, true)
		set_collision_mask_bit(6, true)


func get_hint_text():
	return "Pick Up"


func _process(delta):
	pass
	
	# if player is in range, magnet over there
	#if get_global_position().distance_to(Global.player.get_global_position()) < SNAP_RANGE:
	#	#set_global_position(get_global_position().linear_interpolate(Global.player.get_global_position(), 10 * delta))
	#	move_and_collide(get_global_position().direction_to(Global.player.get_global_position()), false)


# for entity, interact picks them up
func initial_control(player):
	player.add_storage_object(type)
	queue_free()


func stop_control(player):
	pass


func operate():
	pass


# https://godotengine.org/qa/9806/reparent-node-at-runtime
# function for reparenting at realtime
func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	var old_position = child.get_global_position()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	
	child.set_global_position(old_position)


func throw(actor):
	print("item have been thrown")
	
	reparent(self, actor.base.get_node("entity"))
