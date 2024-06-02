extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"..".is_in_group("selected"):
		show()
	for child in get_children():
		if child is MeshInstance3D:
			child.rotate_y(delta)
			child.position.y += float(randi_range(0,10))/10
			child.position.y = clamp(child.position.y,0,1)
