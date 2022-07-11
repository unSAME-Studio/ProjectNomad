extends StaticBody2D

var type
var polygon_id

func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	$LightOccluder2D.occluder.set_polygon($Polygon2D.polygon)
	var point = load("res://objects/buildings/buildpoint.tscn").instance()
	point.type = 'wall'
	add_child(point)

func change_type(type_to):
	match(type_to):
		"empty":
			$CollisionPolygon2D.polygon = []
			$Polygon2D.polygon = []
			$LightOccluder2D.occluder.set_polygon()
		_:
			print(type_to)

func destroy():
	change_type('empty')
