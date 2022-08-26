extends Structure

var connected = null
var controlling = false

var using = false

var recharge_boost = 1
#var speed_boost = 200


func ready():
	self.connect("tree_exiting", self, "destroy")
	#base.add_buff(self)
	#print(base)
	var room
	var result = get_world_2d().get_direct_space_state().intersect_point(position, 6 ,[],32,false,true)
	if (not result.empty()):
		room = result[0].collider
		slot_build_point.bind_point(room)
	else:
		if 'build_points' in get_parent().get_parent():
			slot_build_point.bind_point(get_parent().get_parent())

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
		add_buff(object)

#		object.get_parent().remove_child(object)
#		add_child(object)

func add_buff(buff):
	if buff.type == 'generator':
		recharge_boost = 1.5
	if base.has_method('add_buff'):
		base.add_buff(self)

func disconnect_culpit(clear = false):
	if not clear:
		if connected:
			connected.slotted = null
	connected = null
	recharge_boost = 1
	base.apply_buff()



func _on_Timer_timeout():
	using = false
