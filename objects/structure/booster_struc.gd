extends Structure

var connected = null
var controlling = false

var using = false

var speed_boost = 200

onready var slot_build_point = get_node('buildpoint')

func ready():
	self.connect("tree_exiting", self, "destroy")
	#base.add_buff(self)
	#slot_build_point.bind_point(base)

func destroy():
	if base.has_method('add_buff'):
		base.remove_buff(self)
	if connected:
		connected.destroy()

func connect_culpit(object):
	if object:
		connected = object
		connected.slotted = self
		
		connected.wearing = true
		connected.initial_control(base)
		
		connected.scale = scale
		connected.connect("tree_exiting", self, "disconnect_culpit")
		
		if object.has_method('get_buff'):
			object.get_buff()
		
#		object.get_parent().remove_child(object)
#		add_child(object)

func add_buff(buff):
	if buff.type == 'generator':
		speed_boost = 2
	if base.has_method('add_buff'):
		base.add_buff(self)
		
func disconnect_culpit(clear = false):
	if not connect_failsafe:
		if not clear:
			if connected:
				connected.slotted = null
		connected = null


func _on_Timer_timeout():
	using = false
