extends PanelContainer


var culpit = null


func _process(delta):
	if is_visible() and culpit != null:
		# check if destroyed
		if not is_instance_valid(culpit):
			close()
		
		set_position(culpit.get_global_transform_with_canvas().get_origin() - get_size() / 2 + Vector2(0, -100))
		
		# check mouse position
		#print(get_local_mouse_position().length())
		if get_local_mouse_position().length() > 300:
			close()
		


func connect_culpit(c):
	disconnect_culpit()
	
	culpit = c
	
	$MarginContainer/HBoxContainer/Move.connect("pressed", culpit, "_on_moved")
	$MarginContainer/HBoxContainer/Destroy.connect("pressed", culpit, "_on_destroy")
	
	show()


func disconnect_culpit():
	$MarginContainer/HBoxContainer/Move.disconnect("pressed", culpit, "_on_moved")
	$MarginContainer/HBoxContainer/Destroy.disconnect("pressed", culpit, "_on_destroy")


func close():
	disconnect_culpit()
	culpit = null
	hide()
	
