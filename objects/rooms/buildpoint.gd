extends Area2D


export(String,"utility","room","weapon","wall","snap","core","connector") var type = "Snap"
var active = true
var object = null
var room = null
var target = null
var wall
var indi

func _ready():
	hide()
	if "Wall" in get_parent().name:
		wall = get_parent()
	
	room = find_parent("room")
	if room:
		if type == 'room':
			room.snappoint.append(self)
		room.build_points.append(self)
		self.connect("tree_exiting", self, "disconnect_point")


func activate_build():
	active = true
	
func ready_build():
	show()
	
func end_build():
	hide()

func finish_build(_object):
	active = false
	if _object:
		target = _object
		_object.build_point = self
		
	if wall:
		wall.queue_free()
	end_build()

func disconnect_point():
	if room:
		room.disconnect_point(self)
