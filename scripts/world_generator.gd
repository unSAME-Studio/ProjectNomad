extends Node2D

const Delaunator := preload("res://scripts/voronoi/Delaunator.gd")

var island = preload("res://objects/enviorments/Island.tscn")

var point_bound = 5000
var clip_bound = 5001

var points := PoolVector2Array([
	Vector2(0, 0), Vector2(point_bound, 0), Vector2(point_bound, point_bound), Vector2(0, point_bound)
])
var clip_polygon = PoolVector2Array([
	Vector2(0, 0), Vector2(clip_bound , 0), Vector2(clip_bound , clip_bound ), Vector2(0, clip_bound )
])

var VoronoiHelper
var delaunay
var cells


func _ready():
	randomize()
	
	# generate more points
	for i in range(10):
		points.append(Vector2(round(rand_range(0, point_bound )), round(rand_range(0, point_bound))))
	
	VoronoiHelper = load("res://scripts/voronoi/VoronoiHelper.gd").new()
	delaunay = Delaunator.new(points)
	cells = VoronoiHelper.get_voronoi_cells(points, delaunay)
	
	# clip polygons 
	for i in cells.size():
		var cliped = Geometry.intersect_polygons_2d(clip_polygon, cells[i])
		if cliped.size() > 0:
			cells[i] = cliped.back()
	
	# generate island
	for i in range(10):
		# random generation chance
		if randi() % 2:
			
			var p = island.instance()
			get_parent().call_deferred("add_child", p)
			
			p.generate(cells[i])
			#p.set_global_position(Vector2(0, 0))
			p.set_global_position(Vector2(rand_range(-10000, 10000), rand_range(-10000, 10000)))
