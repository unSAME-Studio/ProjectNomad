extends TextureButton


onready var slot = get_index()
var type = null

func _ready():
	connect("pressed", self, "_on_button_pressed")


func add_object(new_type):
	type = new_type
	
	var texture
	if type in Global.entity_data.keys():
		texture = load("res://arts/resources/%s.png" % type)
	else:
		texture = load("res://arts/culpits/%s.png" % type)
	$TextureRect.set_texture(texture)
	
	set_tooltip(type.capitalize())
	
	set_pressed(true)
	emit_signal("pressed")


func remove_object():
	type = null
	$TextureRect.set_texture(Image.new())


func _on_button_pressed():	
	print("trying to hold ->")
	print(type)
	
	var player = get_node("../../../../..")
	
	# if already wearing the same slot
	if player.wearing == slot:
		set_pressed(false)
		player.hide_object()
	else:
		# do nothing if nothing equipted
		if type == null:
			pass
		
		player.attach_object(slot)
