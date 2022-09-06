extends Culpit


func _ready():
	var culpit_list = Global.culpits_data.keys()
	culpit_list.sort()
	for i in culpit_list:
		var text = "%s-%d-" % [i.capitalize(), Global.culpits_data[i]["cost"]]
		$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.add_item(text, load("res://arts/culpits/%s.png" % i), true)


func initial_control(body):
	print(name + " is being controller")
	user = body
	
	$CanvasLayer/Control.show()


func stop_control(body):
	print("stopping " + name + " from controlling")
	user = null
	
	$CanvasLayer/Control.hide()


func operate(player):
	pass


func _on_ItemList_item_selected(index):
	var target_type = $CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.get_item_text(index)
	#$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.unselect(index)
	target_type = target_type.split("-", false)
	var amount = int(target_type[1])
	target_type = target_type[0].to_lower()
	print("CRAFTER %s %d" % [target_type, amount])
	
	if Global.player.consume_storage_object("nano", amount):
		
		# spawn entity
		var e = entity.instance()

		e.type = target_type
		base.add_child(e)
		
		e.set_global_position($ControlPos.get_global_position())
		e.set_wearing(false)
		e.velocity = Vector2.DOWN.rotated(get_rotation()).normalized() * 1000
		e.throwing = true
