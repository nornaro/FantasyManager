extends Label

func _process(_delta: float) -> void:
	increase_score()


@rpc()
func increase_score():
	var txt = ""
	for who in Autoload.player_labels:
		var pl = Autoload.player_labels[who]
		txt += str(pl)
	text = txt
