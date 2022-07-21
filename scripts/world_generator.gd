extends Node2D

const Delaunator := preload("res://scripts/voronoi/Delaunator.gd")

var island = preload("res://objects/enviorments/Island.tscn")

var points := PoolVector2Array([
	Vector2(0, 0), Vector2(10000, 0), Vector2(10000, 10000), Vector2(0, 10000)
])
var clip_polygon = PoolVector2Array([
	Vector2(0, 0), Vector2(10010, 0), Vector2(10010, 10010), Vector2(0, 10010)
])

var VoronoiHelper
var delaunay
var cells


func _ready():
	randomize()
	
	# generate more points
	for i in range(100):
		points.append(Vector2(round(rand_range(0, 10000)), round(rand_range(0, 10000))))
	
	VoronoiHelper = load("res://scripts/voronoi/VoronoiHelper.gd").new()
	delaunay = Delaunator.new(points)
	cells = VoronoiHelper.get_voronoi_cells(points, delaunay)
	
	# clip polygons 
	for i in cells.size():
		var cliped = Geometry.intersect_polygons_2d(clip_polygon, cells[i])
		if cliped.size() > 0:
			cells[i] = cliped.back()
	
	# generate island
	for i in range(cells.size()):
		# random generation chance
		if randi() % 2:
			
			var p = island.instance()
			get_parent().call_deferred("add_child", p)
			
			p.generate(cells[i])
			p.set_global_position(Vector2(-5000, -5000))
			#p.set_global_position(Vector2(rand_range(-10000, 10000), rand_range(-10000, 10000)))
