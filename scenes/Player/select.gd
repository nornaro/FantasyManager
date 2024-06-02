extends Node3D

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_select_object(event.position)

func _select_object(screen_position):
	var from = %TopDownCamera3D.project_ray_origin(screen_position)
	var to = from + %TopDownCamera3D.project_ray_normal(screen_position) * 1000 # Long enough ray

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to

	var result = space_state.intersect_ray(query)

	if result:
		_process_ray_hit(result)

func _process_ray_hit(result):
	if result.collider:
		var building = result.collider
		print("Building selected: ", building.name)
		if building.has_method("highlight"):
			building.highlight()
