extends Culpit


func _ready():
	var struct_list = Global.structure_data.keys()
	struct_list.sort()
	for i in struct_list:
		var text = "%s" % [i]
		$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.add_item(text, load("res://arts/cards/C_%s.png" % i), true)


func initial_control(body):
	print(name + " is being controller")
	user = body
	
	$CanvasLayer/Control.show()


func stop_control(body):
	print("stopping " + name + " from controlling")
	user = null
	
	$CanvasLayer/Control.hide()


func _on_ItemList_item_selected(index):
	var target_type = $CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.get_item_text(index)
	#target_type = target_type.to_lower()
	
	# currently only print when player is holding nano
	if Global.player.consume_storage_object("nano"):
		
		# spawn card
		Global.player.add_build_card(target_type)
