extends Culpit


func _ready():
	# setting the progress
	$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/HBoxContainer/ProgressBar.set_value(Global.tech_level_count)
	$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/HBoxContainer/ProgressBar.set_max(Global.tech_level_total)
	$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/Level.set_text("Current Level - %s" % Global.tech_level)
	
	# spawn items
	var struct_list = Global.structure_data.keys()
	struct_list.sort()
	for i in struct_list:
		if Global.structure_data[i]["level"] <= Global.tech_level:
			var text = "%s" % [i]
			$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.add_item(text, load("res://arts/cards/C_%s.png" % i), not Global.structure_data[i]["unlocked"])
	
		# setting up next preview
		if Global.structure_data[i]["level"] == Global.tech_level + 1:
			var icon = TextureRect.new()
			icon.set_texture(load("res://arts/cards/C_%s.png" % i))
			icon.set_expand(true)
			icon.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
			icon.set_custom_minimum_size(Vector2(30, 30))
			$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/LevelPreview.add_child(icon)


func initial_control(body):
	print(name + " is being controller")
	user = body
	
	$CanvasLayer/Control.show()
	
	# default open the build menu
	body.get_node("CanvasLayer/Control/VBoxContainer2/HBoxContainer/BuildMenu").active(true)


func stop_control(body):
	print("stopping " + name + " from controlling")
	user = null
	
	$CanvasLayer/Control.hide()
	
	# default close the build menu
	body.get_node("CanvasLayer/Control/VBoxContainer2/HBoxContainer/BuildMenu").active(false)


func _on_ItemList_item_selected(index):
	var target_type = $CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.get_item_text(index)
	#target_type = target_type.to_lower()
	
	# currently only print when player is holding nano
	if Global.player.consume_storage_object("nano"):
		
		# spawn card
		Global.player.add_build_card(target_type)
		
		# disable item
		$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.set_item_disabled(index, true)
		
		# saves to Global that this is unlocked
		Global.structure_data[target_type]["unlocked"] = 1
		Global.tech_level_count += 1
		
		# setting the progress
		$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/HBoxContainer/ProgressBar.set_value(Global.tech_level_count)
		
		# add new items and levels if total reached
		if Global.tech_level_count == Global.tech_level_total:
			Global.tech_level += 1
			Global.tech_level_count = 0
			
			# add new items
			var total_count = 0
			var struct_list = Global.structure_data.keys()
			struct_list.sort()
			
			# clear previews
			for child in $CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/LevelPreview.get_children():
				child.queue_free()
			
			for i in struct_list:
				if Global.structure_data[i]["level"] == Global.tech_level:
					var text = "%s" % [i]
					$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/ItemList.add_item(text, load("res://arts/cards/C_%s.png" % i), true)
					total_count += 1
				
				# setting up next preview
				if Global.structure_data[i]["level"] == Global.tech_level + 1:
					var icon = TextureRect.new()
					icon.set_texture(load("res://arts/cards/C_%s.png" % i))
					icon.set_expand(true)
					icon.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
					icon.set_custom_minimum_size(Vector2(30, 30))
					$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/LevelPreview.add_child(icon)
				
			
			Global.tech_level_total = total_count
			
			$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/Level.set_text("Current Level - %s" % Global.tech_level)
			$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/HBoxContainer/ProgressBar.set_max(Global.tech_level_total)
			$CanvasLayer/Control/PanelContainer/ScrollContainer/VBoxContainer/HBoxContainer/ProgressBar.set_value(0)
