extends Structure

var connected = null
var controlling = false

var using = false

export var rate = 0.5
export var damage_buff = 1.0
export var speed_buff = 1.0
export var cd_multiplyer = 1.0
export(NodePath) var node

var LockTarget
var lockBase
var prenode

func ready():
	if node:
		prenode = get_node(node)
		node = null
	if 'controlled' in base:
		base.controlled.append(self)
		
	var room
	var result = get_world_2d().get_direct_space_state().intersect_point(position, 6 ,[],32,false,true)
	if (not result.empty()):
		room = result[0].collider
		slot_build_point.bind_point(room)
	else:
		if 'build_points' in get_parent().get_parent():
			slot_build_point.bind_point(get_parent().get_parent())
	#self.connect("tree_exiting", self, "destroy")
	#slot_build_point.bind_point(base)
	#slot_build_point.bind_point(get_parent().get_parent())
	
	if prenode:
		yield(get_tree(),"idle_frame")
		$buildpoint.finish_build(prenode)

func destroy():
	base.controlled.erase(self)
	if connected:
		connected.destroy()
	disconnect_culpit(true)

func operate(player):
	if connected:
		if not using:
			if not LockTarget:
				connected.operate(player)
				using = true
				
				$Timer.start(rate)


func connect_culpit(object):
	if object:
		connected = object
		connected.slotted = self
		
		connected.wearing = false
		#connected.initial_control(null)
		

		connected.scale = scale
		connected.connect("tree_exiting", self, "disconnect_culpit")
#		object.get_parent().remove_child(object)
#		add_child(object)
	.connect_culpit(object)


func disconnect_culpit(clear = false):
	if not connect_failsafe:
		if not clear:
			if connected:
				connected.slotted = null
		connected = null


func _process(_delta):
	if using:
		if base.operating == false:
			using = false
#		else:
#			print('reset')
#			using = false
#	if connected and base.controlling:
#		var targetLoc = get_global_mouse_position()
#		if LockTarget:
#			targetLoc = LockTarget.get_global_position()
#			if not using:
#				connected.operate(lockBase)
#				using = true
#				$Timer.start(rate)
#		connected.look_at(targetLoc)


func _on_Timer_timeout():
	using = false
