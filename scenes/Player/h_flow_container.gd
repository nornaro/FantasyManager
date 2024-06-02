extends HFlowContainer

func _ready() -> void:
	#for child in get_children():
		#var building = $Buildings.get_node_or_null(NodePath(child.name))
		#if building:
			#child.icon = building.get_node_or_null(NodePath("SubViewport"))
			
	for child in get_children():
			child.tooltip_text = "Build " + child.name
			
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
