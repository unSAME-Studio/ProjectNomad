extends Polygon2D

onready var initial_position = get_node("../Polygon2D").get_position()


func _process(delta):
	var position_offset = get_global_position() - Global.player.camera.camera.get_camera_position()
	position_offset = (position_offset / 10) * -1
	
	#print(initial_position + position_offset)
	set_position(initial_position + position_offset)
