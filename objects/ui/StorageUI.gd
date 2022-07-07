extends TextureButton


var type = "nano"


func _ready():
	connect("pressed", self, "_on_button_pressed")


func update_button(new_type):
	type = new_type
	$TextureRect.set_texture(load("res://arts/resources/%s.png" % type))


func _on_button_pressed():
	print(type)
	
	$"../../../../..".attach_object(type)
