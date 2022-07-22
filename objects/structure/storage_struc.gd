extends Structure

var connected = null
var controlling = false

var using = false

func _ready():
	._ready()
	base.controlled.append(self)
	self.connect("tree_exiting", self, "destroy")

func destroy():
	base.controlled.erase(self)
	if connected:
		connected.destroy()
	disconnect_culpit()

func operate(player):
	if connected:
		if not using:
			connected.operate(player)
			using = true
			$Timer.start()

func connect_culpit(object):
	if object:
		connected = object
		connected.wearing = true
		connected.initial_control(self)
		connected.connect("tree_exiting", self, "disconnect_culpit")
#		object.get_parent().remove_child(object)
#		add_child(object)

func disconnect_culpit():
	connected = null

func _process(_delta):
	if connected and base.controlling:
		connected.look_at(get_global_mouse_position())


func _on_Timer_timeout():
	using = false
