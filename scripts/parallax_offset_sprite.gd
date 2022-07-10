extends Sprite

onready var initial_position = get_node("../Root").get_position()

export var offset_amount = 1.0


func _process(delta):
	var position_offset = get_global_position() - Global.player.camera.camera.get_camera_position()
	position_offset = (position_offset / 10) * -1 * offset_amount
	
	#print(initial_position + position_offset)
	set_position(initial_position + position_offset)
