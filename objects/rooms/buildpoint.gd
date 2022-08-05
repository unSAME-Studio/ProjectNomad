extends Area2D


export(String,"utility","room","weapon","wall","door","snap","core","connector") var type = "Snap"
var active = true
var object = null
var room = null
var target = null
export(NodePath) var preset = null
var wall
var indi
var bind_list = []

func _ready():
	hide()
	if "Wall" in get_parent().name:
		wall = get_parent()
	
	room = find_parent("room")

	if room:
		bind_point(room)

func bind_point(target):
	if not target in bind_list:
		bind_list.append(target)
		if type == 'room':
			if 'snappoint' in target:
				target.snappoint.append(self)
		target.build_points.append(self)
		room = target
		self.connect("tree_exiting", self, "disconnect_point")

func _process(delta):
	set_global_rotation(Global.player.camera.camera.get_global_rotation())

func activate_build():
	active = true
	
func ready_build():
	show()
	
func end_build():
	hide()

func finish_build(object = null):
	active = false
	
	if object:
		target = object
		object.build_point = self
		
	if get_parent().has_method('connect_culpit'):
		get_parent().connect_culpit(object)
		
	if wall:
		wall.queue_free()
		
	end_build()

func disconnect_point():
	for i in bind_list:
		if i.has_method('disconnect_point'):
			room.disconnect_point(self)
	bind_list = []
