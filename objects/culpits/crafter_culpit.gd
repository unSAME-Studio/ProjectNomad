extends Culpit

var target_type

export var crafter_type = 0

func _ready():
	var culpit_list = Global.culpits_data.keys()
	culpit_list.sort()
	for i in culpit_list:
		if crafter_type in Global.culpits_data[i]["type"]:
			var text = "%s" % [i.capitalize()]
			$CanvasLayer/Control/PanelContainer/HBoxContainer/ScrollContainer/VBoxContainer/ItemList.add_item(text, load("res://arts/culpits/%s.png" % i), true)


func _process(delta):
	if $CanvasLayer/Control/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/PanelContainer2/CraftBtn.is_visible_in_tree():
		if target_type:
			var amount = Global.culpits_data[target_type]["cost"]
			$CanvasLayer/Control/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/PanelContainer2/CraftBtn.set_disabled(amount > Global.player.count_by_type("nano"))


func initial_control(body):
	print(name + " is being controller")
	user = body
	
	# default hide when wearing
	if wearing:
		$CanvasLayer/Control/PanelContainer.hide()
	
	$CanvasLayer/Control.show()


func stop_control(body):
	print("stopping " + name + " from controlling")
	user = null
	
	$CanvasLayer/Control.hide()


func operate(player):
	pass


func _on_ItemList_item_selected(index):
	target_type = $CanvasLayer/Control/PanelContainer/HBoxContainer/ScrollContainer/VBoxContainer/ItemList.get_item_text(index)
	#$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.unselect(index)
	target_type = target_type.to_lower()
	
	$CanvasLayer/Control/PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer/PanelContainer/NanoCost.set_text(String(Global.culpits_data[target_type]["cost"]))
	$CanvasLayer/Control/PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/Description.set_text(Global.culpits_data[target_type]["description"])


func _on_CraftBtn_pressed():
	var amount = Global.culpits_data[target_type]["cost"]
	if Global.player.consume_storage_object("nano", amount):
		
		# spawn entity
		var e = entity.instance()

		e.type = target_type
		base.add_child(e)
		
		e.set_global_position($ControlPos.get_global_position())
		e.set_wearing(false)
		e.velocity = Vector2.DOWN.rotated(get_rotation()).normalized() * 1000
		e.throwing = true


func _on_Toggle_pressed():
	$CanvasLayer/Control/PanelContainer.set_visible(!$CanvasLayer/Control/PanelContainer.is_visible())
