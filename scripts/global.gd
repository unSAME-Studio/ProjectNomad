extends Node


var player

# card type = [Controller, Machine, Decoration, Weapons]
var culpits_data = []


func load_database(file_name: String):
	var data_file = File.new()
	data_file.open("res://%s.json" % file_name, File.READ)
	
	var database = parse_json(data_file.get_as_text())
	
	data_file.close()
	
	return database


func _ready():
	culpits_data = load_database("data")

