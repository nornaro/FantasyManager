extends Control

const GAME_ID = "xcNhLTRbBH"
const SERVER_PORT = 12345
const SERVER_IP = '127.0.0.1'

var multiplayer_scene = preload("res://scenes/Player/mp_player.tscn")
var players_node: Node
var player_name: String
var players := {}
var players_ready := []
var lobby_id := -1

signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what: String)
signal game_log(what: String)


#func _ready() -> void:
	#Steam.lobby_joined.connect(_on_lobby_joined)
	#Steam.lobby_created.connect(_on_lobby_created)

## ENet
func _enet_host_pressed() -> void:
	players_node = get_tree().get_first_node_in_group("Players")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(1)

func _enet_join_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = peer

func add_player(id: int):
	var instance = multiplayer_scene.instantiate()
	instance.player_id = id
	instance.name = str(id)
	players_node.add_child(instance, true)

func remove_player(id: int):
	if !players_node.has_node(str(id)):
		return
	players_node.get_node(str(id)).queue_free()

#
#func _steam_host_pressed() -> void:
	#players_node = get_tree().get_first_node_in_group("Players")
	#var peer = SteamMultiplayerPeer.new()
	#peer.create_host(0, [])
	#multiplayer.multiplayer_peer = peer
	#multiplayer.peer_connected.connect(add_player)
	#multiplayer.peer_disconnected.connect(remove_player)
	#add_player(1)
#
#func _steam_join_pressed(steam_id: int) -> void:
	#var peer = SteamMultiplayerPeer.new()
	#peer.create_client(steam_id, 0, [])
	#multiplayer.multiplayer_peer = peer




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
#func failed_to_connect(response):
		#var FAIL_REASON: String
		#match response:
			#Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST:
				#FAIL_REASON = "This lobby no longer exists."
			#Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED:
				#FAIL_REASON = "You don't have permission to join this lobby."
			#Steam.CHAT_ROOM_ENTER_RESPONSE_FULL:
				#FAIL_REASON = "The lobby is now full."
			#Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR:
				#FAIL_REASON = "Uh... something unexpected happened!"
			#Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED:
				#FAIL_REASON = "You are banned from this lobby."
			#Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED:
				#FAIL_REASON = "You cannot join due to having a limited account."
			#Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED:
				#FAIL_REASON = "This lobby is locked or disabled."
			#Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN:
				#FAIL_REASON = "This lobby is community locked."
			#Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU:
				#FAIL_REASON = "A user in the lobby has blocked you from joining."
			#Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER:
				#FAIL_REASON = "A user you have blocked is in the lobby."
#
#func _on_lobby_created(status: int, new_lobby_id: int):
	#_steam_host_pressed()
	
