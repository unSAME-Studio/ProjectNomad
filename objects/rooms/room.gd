extends Area2D

var base = null
var build_points = []
var active = true
var snappoint = []


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
	base.rooms.append(self)
	base.update_polygon($Polygon2D)
#	if build_points:
#		for i in build_points:
#			i.connect("tree_exiting", self, "disconnect_point")
	#print($Polygon2D.polygon)

# will return the base
func get_build():
	return base
	
func get_build_points():

	return build_points
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func disconnect_point(point):
	if active:
		print(point)
		build_points.erase(point)
		snappoint.erase(point)
