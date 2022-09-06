extends StaticBody2D

class_name Wall

var type = 'wall'
var polygon_id
var polygon
var actived = true
var base = null

var level = 0
export var sp = false

func _ready():
	var point = load("res://objects/buildings/buildpoint.tscn").instance()
	point.type = 'wall'
	add_child(point)
	if sp:
		active()

func active():
	if get_parent().get_parent().has_method('get_base'):
		base = get_parent().get_parent().get_base()
	else:
		if 'base' in get_parent():
			base = get_parent().base
		else:
			base = get_parent()
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

func upgrade():
	if find_node("DamageComponent"):
		if level == 0:
			level += 1
			$Polygon2D.color = '8c8c54'
			get_node("DamageComponent").health_max += 100
			get_node("DamageComponent").reset()
		

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
