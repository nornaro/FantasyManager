extends Control

func _process(_delta: float) -> void:
	Autoload.block_click = true
	if get_global_mouse_position().y < $Control.global_position.y:
		Autoload.block_click = false


func _on_position_reset_pressed() -> void:
	get_tree().call_group("camera","_on_position_reset_pressed")


func _on_rotation_reset_pressed() -> void:
	get_tree().call_group("camera","_on_rotation_reset_pressed")
