extends Structure

var connected = null
var controlling = false

var using = false

export var rate = 0.25
export var damage_buff = 1.0
export var speed_buff = 1.0
export var cd_multiplyer = 1.0
export(NodePath) onready var node = get_node(node)

var LockTarget


func ready():
	base.controlled.append(self)
	self.connect("tree_exiting", self, "destroy")
	#slot_build_point.bind_point(base)
	slot_build_point.bind_point(get_parent().get_parent())

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
			if player.has_method('get_targets'):
				LockTarget = player.get_targets(self)

func connect_culpit(object):
	if object:
		connected = object
		connected.slotted = self
		
		connected.wearing = true
		connected.initial_control(base)
		

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
	var targetLoc = get_global_mouse_position()
	if LockTarget:
		if LockTarget.is_instance_valid():
			targetLoc = LockTarget.get_global_position()
		else:
			LockTarget = null
		var p = PoolVector2Array([Vector2.ZERO, to_local(targetLoc)])
		$Line2D.set_points(p)

	
	if connected and base.controlling:
		connected.look_at(targetLoc)


func _on_Timer_timeout():
	using = false
