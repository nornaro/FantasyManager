extends Panel
#
#func _setup_ui():
	#Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	#Steam.lobby_match_list.connect(fill_loby_menu)
	#Steam.addRequestLobbyListStringFilter("game", NetworkMgr.GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)
	#Steam.requestLobbyList()
#
#func fill_loby_menu(lobbies: Array):
	#for lobby in lobbies:
		#if NetworkMgr.lobby_id.text != "" and not (str(lobby).contains(NetworkMgr.lobby_id.text) or str(Steam.getLobbyData(lobby, "name")).contains(NetworkMgr.lobby_id.text)):
			#return
		#NetworkMgr.lobby_name.add_item(" " + Steam.getLobbyData(lobby, "info"))
		#NetworkMgr.lobby_name.add_item(" " + Steam.getLobbyData(lobby, "name"))
		#NetworkMgr.lobby_players.add_item(" " + str(Steam.getNumLobbyMembers(lobby)), null, false)
		#NetworkMgr.lobby_id.add_item(str(lobby), null, false)

#
#@rpc("call_local", "any_peer")
#func register_player(new_player_name: String):
	#var id = multiplayer.get_unique_id()
	#players[id] = str(id)
	#player_list_changed.emit()
	#var player_scene = preload("res://scenes/Player/mp_player.tscn")
	#var player = player_scene.instantiate()
	#player.name = str(multiplayer.get_unique_id())
	#player.position = position
	#player.set_player_name(str(id))
	#get_tree().get_first_node_in_group("Players").add_child(player)
	#player.set_multiplayer_authority(multiplayer.get_unique_id())



#func _on_lobby_joined(new_lobby_id: int, _permissions: int, _locked: bool, response: int):
	#if response != Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		#failed_to_connect(response)
		#return
	#lobby_id = new_lobby_id
	#var id = Steam.getLobbyOwner(new_lobby_id)
	#if id != Steam.getSteamID():
		#_steam_join_pressed(id)
		#add_player(id)
		#players[multiplayer.get_unique_id()] = player_name
	#
	#
	
	
#func _ready() -> void:
	#Steam.lobby_joined.connect(_on_lobby_joined)
	#Steam.lobby_created.connect(_on_lobby_created)

#func _on_lobby_created(status: int, new_lobby_id: int):
	#_steam_host_pressed()
	
