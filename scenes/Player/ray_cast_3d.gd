extends Node3D

@export var camera: Camera3D

func _process(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Calculate the ray origin and direction
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	var ray_length = 1000 # Adjust the ray length as needed
	
	# Create a PhysicsRayQueryParameters3D instance and set its parameters
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = ray_origin
	ray_query.to = ray_origin + ray_direction * ray_length
	
	# Perform the intersection query
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(ray_query)
	
	# Check if something was hit
	if result:
		var object = result.collider
		if !object:
			return
		if !object.get_parent():
			return
		if not object.get_parent().is_in_group("pointover"):
			get_tree().call_group("pointover", "remove_from_group", "pointover")
			object.get_parent().add_to_group("pointover")
			
# Input event handler to handle mouse clicks
func _input(_event: InputEvent) -> void:
	if %MenuBar.block_click:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		get_tree().call_group("selected", "deselect")
		get_tree().call_group("selected", "remove_from_group", "selected")
		get_tree().call_group("pointover", "add_to_group", "selected")
		get_tree().call_group("pointover", "select", "")
