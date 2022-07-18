extends Node2D


onready var camera = get_node("Camera2D")

export(NodePath) var target_node_path
onready var target = get_node(target_node_path)
var align_flag = false
var rotation_temp = 0
var rotation_changed_flag = true
var align_fix = 0
func _ready():
	target.camera = self
	#camera.rotating = true

func align_camera():
	align_flag = true



func _unhandled_input(event):
	if Input.is_action_just_pressed("zoom_reset"):
		camera.set_zoom(Vector2(1, 1))
	
	if Input.is_action_just_pressed("camera_align"):
		align_camera()
	
	if Input.is_action_just_pressed("camera_left"):
		pass
	
	if Input.is_action_just_pressed("camera_right"):
		pass


func _get_rotation():
	return rotation_temp


func _process(delta):
	# camera control
	if Input.is_action_pressed("zoom_in"):
		var new_zoom = clamp(camera.get_zoom().x * 0.9, 0.5, 3)
		camera.set_zoom(lerp(camera.get_zoom(), Vector2(new_zoom, new_zoom), 20 * delta))
		
	if Input.is_action_pressed("zoom_out"):
		var new_zoom = clamp(camera.get_zoom().x * 1.1, 0.5, 3)
		camera.set_zoom(lerp(camera.get_zoom(), Vector2(new_zoom, new_zoom), 20 * delta))
	
	
	set_global_position(target.get_global_position())
	
	
	#movement inheritance check @walk_state.gd
	if not rotation_changed_flag:
		if align_flag:
			rotation_temp = target.get_global_rotation()
		else:
			rotation_temp = get_global_rotation()
			
			
	# rotate camera toward player when not 
	if align_flag:#Global.player.state.get_class() != "ControlState" and align_flag:
		set_global_rotation(lerp_angle(get_global_rotation(), target.get_global_rotation(), 10 * delta))
		if abs(get_global_rotation() - target.get_global_rotation()) < 0.1:
			#set_global_rotation(target.get_global_rotation())
			align_flag = false
			align_fix = 0.1
			
	if abs(get_global_rotation() - target.get_global_rotation()) < 0.1 and align_fix > 0:
		set_global_rotation(lerp_angle(get_global_rotation(), target.get_global_rotation(), 20 * delta))
		align_fix -= delta
		#print(align_fix)
		
	
	# move the parallax layers
	for i in $Parallax/Control.get_children():
		i.get_material().set_shader_param("offset", $Camera2D.get_camera_screen_center())
		i.get_material().set_shader_param("rot_offset", get_global_rotation())
		i.get_material().set_shader_param("zoom", $Camera2D.get_zoom().x)
		#print($Camera2D.get_camera_position())
