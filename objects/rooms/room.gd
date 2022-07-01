extends Area2D

var base = null
var build_points = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$structures/Wall/CollisionPolygon2D.polygon = $structures/Wall/Polygon2D.polygon
	$structures/Wall/LightOccluder2D.occluder.set_polygon($structures/Wall/Polygon2D.polygon)
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	base = get_parent().get_parent()
	base.rooms.append(self)
	build_points = $structures/points.get_children()
	for i in build_points:
		i.room = self

	#pass
#will return the base
func get_build():
	return base
	
func get_build_points(type):
	var out_points = []
	for i in $structures/points.get_children():
		if i.type == type:
			out_points.append(i)
	return out_points
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
