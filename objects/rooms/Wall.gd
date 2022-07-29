extends StaticBody2D

class_name Wall

var type = 'wall'
var polygon_id
var polygon
var actived = true
var base = null

func _ready():
	var point = load("res://objects/buildings/buildpoint.tscn").instance()
	point.type = 'wall'
	add_child(point)
	base = get_parent().get_parent().get_base()
	ready()

func ready():
	polygon = $Polygon2D
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	$LightOccluder2D.occluder.set_polygon($Polygon2D.polygon)
	
func get_base():
	return get_parent().get_parent().get_base()

func deactivate():
	pass

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
			

func switch():
	if actived:
		destroy()
	else:
		repair()

func destroy():
	change_type('empty')
	actived = false
	
func _on_destroy():
	destroy()
	$DamageComponent.reset()
	
func repair():
	change_type('wall')
	actived = true
