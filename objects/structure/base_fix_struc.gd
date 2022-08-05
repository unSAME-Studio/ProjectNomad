
extends Structure

var connected = null
var controlling = false

var using = false

export var rate = 0.25
export var damage_buff = 10.0
export var speed_buff = 2.5
export var cd_multiplyer = 10.0
var reset_angle = false

onready var slot_build_point = get_node('buildpoint')

func _ready():
	base.controlled.append(self)
	self.connect("tree_exiting", self, "destroy")
	#slot_build_point.bind_point(base)

func destroy():
	base.controlled.erase(self)
	if connected:
		connected.destroy()
	disconnect_culpit(true)

func operate(player):
	if connected:
		if not using:
			connected.operate(player)
			using = true
			$Timer.start(rate)

func connect_culpit(object):
	if object:
		connected = object
		connected.slotted = self
		
		connected.wearing = true
		connected.initial_control(base)
		
		connected.scale = scale * Vector2(2,1)
		connected.connect("tree_exiting", self, "disconnect_culpit")
	.connect_culpit(object)
#		object.get_parent().remove_child(object)
#		add_child(object)

func disconnect_culpit(clear = false):
	if not clear:
		connected.slotted = null
	connected = null
	reset_angle = false

func _process(_delta):
	if connected:
		if not reset_angle:
			if connected.rotation_degrees == -90:
				reset_angle = true
			connected.rotation_degrees = -90
		if base.controlling:
			var local_mouse = to_local(get_global_mouse_position())
			var aim_angle = local_mouse.angle_to_point(Vector2.ZERO)
			if abs(aim_angle + 1.57) < 0.3:
				connected.set_rotation(aim_angle)
			else:
				if local_mouse.x > 0:
					connected.set_rotation(-1.27)
				else:
					connected.set_rotation(-1.87)

			
#			if(aim_angle + 1.57 > 0):
#				connected.set_rotation(-1.27)
#				#connected.set_rotation_degrees(-90)
#			if(aim_angle + 1.57 < 0):
#				connected.set_rotation(-1.87)
#			pass
			#connected.set_global_rotation()


func _on_Timer_timeout():
	using = false

