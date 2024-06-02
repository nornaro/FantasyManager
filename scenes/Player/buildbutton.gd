extends Button

var id = 1

func _on_pressed() -> void:
	get_tree().call_group("selected", "build", name)
