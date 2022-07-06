extends KinematicBody2D

class_name Entity

const SNAP_RANGE = 300

export(String) var type = "nano"
var action = true
var wearing = false


func _ready():
	# if player is weearing this, it shouldn't be interactable or collision
	if wearing:
		set_collision_layer_bit(6, false)
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(3, false)
		set_collision_mask_bit(6, false)


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
	# check for empty slot inside dictionary
	var slot = player.find_storage_space()
	if slot != null:
		player.storage[slot] = type
		player.storage_ui[slot].update_button(type)
	
		queue_free()


func stop_control(player):
	pass


func operate():
	pass


func throw():
	pass
