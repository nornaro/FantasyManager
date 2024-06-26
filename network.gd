extends Control


func _on_host_pressed() -> void:
	print(%TabBar.current_tab)
	match %TabBar.current_tab:
		0:
			NetworkMgr._enet_host_pressed()
		1:
			NetworkMgr._steam_host_pressed()
	%Network.hide()
	%MenuBar.show()
	%InfoBar.show()


func _on_join_pressed() -> void:
	match %TabBar.current_tab:
		0:
			NetworkMgr._enet_join_pressed()
		1:
			NetworkMgr._steam_join_pressed(Steam.getSteamID())
	%Network.hide()
	%MenuBar.show()
	%InfoBar.show()
