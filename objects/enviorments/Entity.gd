extends KinematicBody2D

class_name Entity

const SNAP_RANGE = 300

export(String) var type = "nano"


func _ready():
	pass


func _process(delta):
	pass
	
	# if player is in range, magnet over there
	if get_global_position().distance_to(Global.player.get_global_position()) < SNAP_RANGE:
		#set_global_position(get_global_position().linear_interpolate(Global.player.get_global_position(), 10 * delta))
		move_and_collide(get_global_position().direction_to(Global.player.get_global_position()), false)
