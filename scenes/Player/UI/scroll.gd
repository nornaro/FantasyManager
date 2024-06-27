extends Control

var prev_vector: Vector2 = Vector2()
var scroll_vector: Vector2 = Vector2()
var margin: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_position = get_viewport().get_mouse_position()
	scroll_vector = Vector2()
	
	# Check horizontal edges and corners
	if mouse_position.x <= margin:
		scroll_vector.y += 1 # Left is Up
	if mouse_position.x >= viewport_size.x - margin:
		scroll_vector.y -= 1 # Right is Down
	
	# Check vertical edges and corners
	if mouse_position.y <= margin:
		scroll_vector.x -= 1 # Up is Right
	if mouse_position.y >= viewport_size.y - margin:
		scroll_vector.x += 1 # Down is Left
	
	# Emit signal if there is a change in scroll_vector
	if prev_vector != scroll_vector:
		emit_signal("scroll", scroll_vector)
		prev_vector = scroll_vector
