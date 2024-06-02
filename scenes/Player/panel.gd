extends Control

func _process(_delta: float) -> void:
	Autoload.block_click = true
	if get_global_mouse_position().y < $Control.global_position.y:
		Autoload.block_click = false
