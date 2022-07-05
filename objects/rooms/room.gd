extends Area2D

var base = null
var build_points = []
var active = true
var snappoint


func _ready():
	snappoint = $snappoint
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	if active == true:
		active(get_parent().get_parent())
	else:
		set_modulate(Color('48ffffff'))


func active(_base):
	
	set_modulate(Color('ffffffff'))
	base = _base
	base.rooms.append(self)
	base.update_polygon($Polygon2D)
	#print($Polygon2D.polygon)

# will return the base
func get_build():
	return base
	
func get_build_points(type):
	var out_points = []
	for i in build_points:
		if i.type == type:
			if i.active == true:
				out_points.append(i)
	if type == 'Wall':
		for i in $structures.get_children():
			if i.name != 'points':
				out_points.append(i)
	return out_points
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
