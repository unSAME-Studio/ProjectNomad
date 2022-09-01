extends Node


var player

var culpits_data = []
var entity_data = []
var structure_data = []

var tech_level = 0
var tech_level_count = 0
var tech_level_total = 1


func load_database(file_name: String):
	var data_file = File.new()
	data_file.open("res://%s.json" % file_name, File.READ)
	
	var database = parse_json(data_file.get_as_text())
	
	data_file.close()
	
	return database


func _ready():
	print("LOADING JSON")
	var data = load_database("data")
	
	culpits_data = data["culpit"]
	entity_data = data["entity"]
	structure_data = data["structure"]
	
	print("JSON LOAD SUCCSEFUL")
