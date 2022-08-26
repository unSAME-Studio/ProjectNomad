extends Area2D

var base = null
var build_points = []
var active = true
var snappoint = []

var linked_rooms = []

func _ready():
	#snappoint = $snappoint
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	if active == true:
		active(get_parent().get_parent())
	else:
		set_modulate(Color('48ffffff'))


func active(_base):
	active = true
	set_modulate(Color('ffffffff'))
	base = _base
	if base:
		base.rooms.append(self)
		base.update_polygon($Polygon2D)
	for i in $structures.get_children():
		if i.has_method('active'):
			i.active()
	for i in $objects.get_children():
		if i.has_method('active'):
			i.active()
			
func deactive():
	active = false
	set_modulate(Color('ffffff66'))
	if base:
		base.rooms.erase(self)
		base.update_polygon($Polygon2D,true)
	for i in $structures.get_children():
		if i.has_method('destroy'):
			i.destroy()
	for i in $objects.get_children():
		if i.has_method('destroy'):
			i.destroy()
	
#	if build_points:
#		for i in build_points:
#			i.connect("tree_exiting", self, "disconnect_point")
	#print($Polygon2D.polygon)

func get_base():
	return get_parent().get_parent()

# will return the base
func get_build():
	return base
	
func destroy():
	for i in linked_rooms:
		if i.get_ref():
			i.get_ref().destroy()
			
	deactive()
	queue_free()
	
	
func get_build_points():
	return build_points
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func disconnect_point(point):
	if active:
		build_points.erase(point)
		snappoint.erase(point)
		Global.player.build_point_flag
