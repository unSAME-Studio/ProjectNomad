extends "res://objects/object_base.gd"


var tree = preload("res://objects/enviorments/Tree.tscn")
var rock = preload("res://objects/enviorments/Rock.tscn")
var entity = preload("res://objects/entities/Entity.tscn")

export var special = false

func _ready():
	if special:
		$Shadow.polygon = $Polygon2D.polygon
		
		$CollisionPolygon2D.polygon = $Polygon2D.polygon

func generate(polygon):
	$Polygon2D.polygon = polygon
	#$Polygon2D.color = Color(randf(), randf(), randf(), 0.6)
	$Shadow.polygon = polygon
	
	$CollisionPolygon2D.polygon = polygon
	#$VisibilityEnabler2D.set_rect($Polygon2D.)
	
	# find max and min point
	var max_point = Vector2.ZERO
	var min_point = Vector2.ZERO
	
	for point in polygon:
		if point.x > max_point.x:
			max_point.x = point.x
		
		if point.y > max_point.y:
			max_point.y = point.y
			
		if point.x < min_point.x:
			min_point.x
		
		if point.y < min_point.y:
			min_point.y
	
	print(max_point)
	print(min_point)
	
	# generate a bunch of trees
	for i in range(randi() % 3):
		var t = tree.instance()
		$entity.add_child(t)
		
		var pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		while not Geometry.is_point_in_polygon(pos, $Polygon2D.get_polygon()):
			pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		
		t.set_global_position(pos)
		t.set_rotation(rand_range(0, PI))
		
	# generate a bunch of rocks
	for i in range(randi() % 2):
		var t = rock.instance()
		$entity.add_child(t)
		
		var pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		while not Geometry.is_point_in_polygon(pos, $Polygon2D.get_polygon()):
			pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		
		t.set_global_position(pos)
		t.set_rotation(rand_range(0, PI))
		
	# generate a bunch of random items
	for i in range(randi() % 10):
		var e = entity.instance()
		e.type = Global.entity_data.keys()[randi() % Global.entity_data.size()]
		e.data = null
		
		$entity.add_child(e)
		
		var pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		while not Geometry.is_point_in_polygon(pos, $Polygon2D.get_polygon()):
			pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		
		e.set_global_position(pos)
		e.set_rotation(rand_range(0, PI))
