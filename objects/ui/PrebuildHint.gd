extends Label


var prebuild = null


func _process(delta):
	# check if prebuild still exist
	if not is_instance_valid(prebuild):
		hide()
		return
	
	if is_visible():
		var target_pos = prebuild.get_global_transform_with_canvas().get_origin() - get_size() / 2
		target_pos = Vector2(clamp(target_pos.x, 0, get_viewport_rect().size.x - get_size().x), clamp(target_pos.y, 0, get_viewport_rect().size.y - get_size().y))
		#set_position(target_pos)
		set_position(get_position().linear_interpolate(target_pos, 20 * delta))
