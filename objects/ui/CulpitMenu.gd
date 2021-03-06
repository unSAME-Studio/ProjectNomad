extends PanelContainer


var culpit = null


func _process(delta):
	if is_visible() and culpit != null:
		# check if destroyed
		if not is_instance_valid(culpit):
			close()
			return
		
		# draw a line
		#draw_line(get_global_position())
		
		var target_pos = culpit.get_global_transform_with_canvas().get_origin() - get_size() / 2 + Vector2(0, -100)
		target_pos = Vector2(clamp(target_pos.x, 0, get_viewport_rect().size.x - get_size().x), clamp(target_pos.y, 0, get_viewport_rect().size.y - get_size().y))
		#set_position(get_position().linear_interpolate(target_pos, 0.2))
		set_position(target_pos)
		
		# check mouse position
		#print(get_local_mouse_position().length())
		if culpit.get_local_mouse_position().length() > 300:
			close()



func connect_culpit(c):
	disconnect_culpit()
	
	culpit = c
	
	$MarginContainer/HBoxContainer/Move.connect("pressed", culpit, "_on_moved")
	$MarginContainer/HBoxContainer/Destroy.connect("pressed", culpit, "_on_destroy")
	
	show()


func disconnect_culpit():
	if is_instance_valid(culpit):
		$MarginContainer/HBoxContainer/Move.disconnect("pressed", culpit, "_on_moved")
		$MarginContainer/HBoxContainer/Destroy.disconnect("pressed", culpit, "_on_destroy")


func close():
	disconnect_culpit()
	culpit = null
	hide()
	
