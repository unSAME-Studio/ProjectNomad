extends Node2D


onready var camera = get_node("Camera2D")

export(NodePath) var target



func _input(event):
	# camera control
	if Input.is_action_just_pressed("zoom_in"):
		var new_zoom = clamp(camera.get_zoom().x * 0.9, 0.2, 3)
		camera.set_zoom(Vector2(new_zoom, new_zoom))
		
	if Input.is_action_just_pressed("zoom_out"):
		var new_zoom = clamp(camera.get_zoom().x * 1.1, 0.2, 3)
		camera.set_zoom(Vector2(new_zoom, new_zoom))
		
	if Input.is_action_just_pressed("zoom_reset"):
		camera.set_zoom(Vector2(1, 1))


func _process(delta):
	set_global_position(get_node(target).get_global_position())
