extends Control

var block_click = false

func _process(_delta: float) -> void:
	block_click = true
	if get_global_mouse_position().y < $Control.global_position.y:
		block_click = false
