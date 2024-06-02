extends Control

signal scroll(Vector2)
var prev_vector: Vector2
var scroll_vector: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$L.size = Vector2(20,size.y)
	$R.size = Vector2(20,size.y)
	$U.size = Vector2(size.x,20)
	$D.size = Vector2(size.x,20)
	$L.position = Vector2(0,0)
	$R.position = Vector2(size.x-10,0)
	$U.position = Vector2(0,0)
	$D.position = Vector2(0,size.y-10)

func _process(_delta: float) -> void:
	if prev_vector == scroll_vector:
		return
	scroll.emit(scroll_vector)
	#emit_signal("scroll", scroll_vector)
	prev_vector = scroll_vector

func _on_l_mouse_entered() -> void:
	scroll_vector += Vector2.DOWN
func _on_l_mouse_exited() -> void:
	scroll_vector -= Vector2.DOWN
func _on_r_mouse_entered() -> void:
	scroll_vector += Vector2.UP
func _on_r_mouse_exited() -> void:
	scroll_vector -= Vector2.UP
func _on_u_mouse_entered() -> void:
	scroll_vector += Vector2.LEFT
func _on_u_mouse_exited() -> void:
	scroll_vector -= Vector2.LEFT
func _on_d_mouse_entered() -> void:
	scroll_vector += Vector2.RIGHT
func _on_d_mouse_exited() -> void:
	scroll_vector -= Vector2.RIGHT




	pass # Replace with function body.
