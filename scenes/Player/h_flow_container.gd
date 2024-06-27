extends HFlowContainer

var current_menu_index = 0

func _ready() -> void:
	#for child in get_children():
		#var building = $Buildings.get_node_or_null(NodePath(child.name))
		#if building:
			#child.icon = building.get_node_or_null(NodePath("SubViewport"))
			
		get_tree().call_group("Buildings","name_children")
				
	#for num in get_child_count():
		#var id = get_child(num).id 
		#if id:
			#get_child(num).tooltip_text = "Build " + get_child(num).name + "("+str(num)+")"
		#
#func _process(_delta: float) -> void:
	#if name.contains("1"):
		#Input.is
	#for num in get_child_count():
		#if num >= 10:
			#return
		#if Input.is_action_just_pressed(str(num)):
			#get_child(num)._on_pressed()

func _input(_event: InputEvent) -> void:
	var build_menu = get_tree().get_nodes_in_group("Buildings")
	if Input.is_action_just_pressed("MenuLoop"):
		current_menu_index += 1
		if current_menu_index == build_menu.size():
			current_menu_index = 0
		get_tree().call_group("RollableMenu","hide")
		build_menu[current_menu_index].show()
