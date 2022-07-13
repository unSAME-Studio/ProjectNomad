extends StaticBody2D

class_name Wall

var type
var polygon_id
var polygon

func _ready():
	var point = load("res://objects/buildings/buildpoint.tscn").instance()
	point.type = 'wall'
	add_child(point)
	ready()

func ready():
	polygon = $Polygon2D
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	$LightOccluder2D.occluder.set_polygon($Polygon2D.polygon)

func change_type(type_to):
	polygon.hide()
	match(type_to):
		'empty':
			$CollisionPolygon2D.polygon = []
			$LightOccluder2D.occluder.set_polygon([])
		'wall':
			polygon = $Polygon2D
			polygon.show()
			$CollisionPolygon2D.polygon = $Polygon2D.polygon
			$LightOccluder2D.occluder.set_polygon($Polygon2D.polygon)
		'door':
			polygon.show()
			$CollisionPolygon2D.polygon = polygon.polygon
			$LightOccluder2D.occluder.set_polygon(polygon.polygon)
		_:
			print(type_to)
			

func destroy():
	change_type('empty')
	
func repair():
	change_type('wall')
