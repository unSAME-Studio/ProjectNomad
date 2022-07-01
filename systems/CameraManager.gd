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

func _unhandled_input(event):
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
	
	# rotate camera toward player when not 
	if Global.player.state.get_class() != "ControlState":
		set_global_rotation(lerp_angle(get_global_rotation(), target.get_global_rotation(), 10 * delta))
	
	# move the parallax layers
	for i in $Parallax/Control.get_children():
		i.get_material().set_shader_param("offset", $Camera2D.get_camera_position())
		i.get_material().set_shader_param("rot_offset", get_global_rotation())
		i.get_material().set_shader_param("zoom", $Camera2D.get_zoom().x)
		#print($Camera2D.get_camera_position())
