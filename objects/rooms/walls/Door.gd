extends Wall


func ready():
	polygon = $Polygon2D
#	$CollisionPolygon2D.polygon = $Polygon2D.polygon
#	$LightOccluder2D.occluder.set_polygon($Polygon2D.polygon)
	var point = load("res://objects/buildings/buildpoint.tscn").instance()
	point.type = 'door'
	add_child(point)

func spawn_door():
	pass

func destroy():
	hide()
	$CollisionPolygon2D2.polygon = []
	$CollisionPolygon2D.polygon = []
	$LightOccluder2D.occluder.polygon = []
	$LightOccluder2D2.occluder.polygon = []
	for i in $structure.get_children():
		i.destroy()
	
func restore():
	show()
	$CollisionPolygon2D2.polygon = []
	$CollisionPolygon2D.polygon = []
	$LightOccluder2D.occluder.polygon = []
	$LightOccluder2D2.occluder.polygon = []	
