extends Node2D


onready var camera = get_node("Camera2D")

export(NodePath) var target_node_path
onready var target = get_node(target_node_path)


func _ready():
	target.camera = self
	#camera.rotating = true

func align_camera():
	#camera.rotation = target.get_global_rotation()
	pass

func _input(event):
	# camera control
	if Input.is_action_just_pressed("zoom_in"):
		var new_zoom = clamp(camera.get_zoom().x * 0.9, 0.5, 3)
		camera.set_zoom(Vector2(new_zoom, new_zoom))
		
	if Input.is_action_just_pressed("zoom_out"):
		var new_zoom = clamp(camera.get_zoom().x * 1.1, 0.5, 3)
		camera.set_zoom(Vector2(new_zoom, new_zoom))
		
	if Input.is_action_just_pressed("zoom_reset"):
		camera.set_zoom(Vector2(1, 1))


func _process(delta):
	set_global_position(target.get_global_position())
	set_global_rotation(target.get_global_rotation())
