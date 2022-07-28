extends "res://objects/object_base.gd"

const MAX_COORD = pow(2,31)-1
const MIN_COORD = -MAX_COORD

var box # your polygon bounding box (Rect2)

var tree = preload("res://objects/enviorments/Tree.tscn")
var rock = preload("res://objects/enviorments/Rock.tscn")
var entity = preload("res://objects/entities/Entity.tscn")
var boys = preload("res://objects/characters/enemy/StupidBoy.tscn")

export var special = false


func _ready():
	if special:
		$Shadow.polygon = $Polygon2D.polygon
		
		$CollisionPolygon2D.polygon = $Polygon2D.polygon


# https://www.reddit.com/r/godot/comments/b0r9l4/is_it_possible_to_get_the_bounding_box_of_a/
func minv(curvec, newvec):
	return Vector2(min(curvec.x, newvec.x),min(curvec.y, newvec.y))

func maxv(curvec,newvec):
	return Vector2(max(curvec.x, newvec.x),max(curvec.y, newvec.y))


func find_center(points):
	var pos = Vector2.ZERO
	for i in points:
		pos += i
	
	return pos / points.size()


func generate(polygon):
	
	# find center of this polygon
	var center = find_center(polygon)
	print(center)
	
	# move this polygon points all by center
	var new_polygon = PoolVector2Array([])
	for i in polygon:
		new_polygon.append(i - center)
	
	set_position(center)
	
	$Polygon2D.polygon = new_polygon
	$Polygon2D.color = Color(randf(), randf(), randf(), 0.6)
	$Shadow.polygon = new_polygon
	
	$CollisionPolygon2D.polygon = new_polygon
	#$VisibilityEnabler2D.set_rect($Polygon2D.)
	
	
	# find bound (max and min point)
	var min_point = Vector2(MAX_COORD, MAX_COORD)
	var max_point = Vector2(MIN_COORD, MIN_COORD)
	for v in new_polygon:
		min_point = minv(min_point, v)
		max_point = maxv(max_point, v)
	box = Rect2(min_point, max_point-min_point)
	
	print("Area: %d" % box.get_area())
	
	# generate a bunch of trees
	for _i in range(randi() % 3):
		var t = tree.instance()
		
		var pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		while not Geometry.is_point_in_polygon(pos, $Polygon2D.get_polygon()):
			pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		
		$entity.add_child(t)
		t.set_position(pos)
		t.set_rotation(rand_range(0, PI))
		
	# generate a bunch of rocks
	for _i in range(randi() % 2):
		var t = rock.instance()
		
		var pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		while not Geometry.is_point_in_polygon(pos, $Polygon2D.get_polygon()):
			pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		
		$entity.add_child(t)
		t.set_position(pos)
		t.set_rotation(rand_range(0, PI))
		
	# generate a bunch of random items
	for _i in range(randi() % 10):
		var e = entity.instance()
		e.type = Global.entity_data.keys()[randi() % Global.entity_data.size()]
		e.data = null
		
		
		var pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		while not Geometry.is_point_in_polygon(pos, $Polygon2D.get_polygon()):
			pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		
		$entity.add_child(e)
		e.set_position(pos)
		e.set_rotation(rand_range(0, PI))
	
	# [TEMP]
	# generate some stupid boys
	for _i in range(randi() % 5):
		var e = boys.instance()
		
		
		var pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		while not Geometry.is_point_in_polygon(pos, $Polygon2D.get_polygon()):
			pos = Vector2(rand_range(min_point.x, max_point.x), rand_range(min_point.y, max_point.y))
		
		add_child(e)
		e.set_position(pos)
