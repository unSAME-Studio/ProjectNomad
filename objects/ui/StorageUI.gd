extends TextureButton


onready var slot = get_index()
onready var player = get_node("../../../../..")
var type = null

var box_storing = null


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
	
	# special set box icons
	if type == "box":
		if player.storage[slot]["data"] != null:
			update_box_info(player.storage[slot]["data"]["storing"], player.storage[slot]["data"]["count"])
	
	set_tooltip(type.capitalize())
	
	set_pressed(true)
	emit_signal("pressed")
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rect_scale", Vector2(1.1, 1.1), 0.05)
	tween.tween_property(self, "rect_scale", Vector2(1, 1), 0.05)


func remove_object():
	type = null
	$TextureRect.set_texture(Image.new())
	
	box_storing = null
	$Additional/Icon.set_texture(Image.new())
	$Additional/Count.set_text("")
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rect_scale", Vector2(0.9, 0.9), 0.05)
	tween.tween_property(self, "rect_scale", Vector2(1, 1), 0.05)


func update_box_info(storing, count):
	# only update when different type icon
	if storing != box_storing:
		box_storing = storing
		
		var icon_texture
		if type == null:
			icon_texture = ImageTexture.new()
		else:
			if storing in Global.entity_data.keys():
				icon_texture = load("res://arts/resources/%s.png" % storing)
			else:
				icon_texture = load("res://arts/culpits/%s.png" % storing)
			
		$Additional/Icon.set_texture(icon_texture)
	
	# set count
	$Additional/Count.set_text(String(count))


func _on_button_pressed():	
	print("trying to hold ->")
	print(type)
	
	# if already wearing the same slot
	if player.wearing == slot:
		set_pressed(false)
		player.hide_object()
	else:
		# do nothing if nothing equipted
		if type == null:
			pass
		
		player.attach_object(slot)
