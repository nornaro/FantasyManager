extends Node

const DEFAULT_PORT = 10567
const MAX_PEERS = 12
const GAME_ID = "xcNhLTRbBH"

var peer: MultiplayerPeer = null
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

func _ready():
	Steam.steamInitEx(true, 480)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_created.connect(_on_lobby_created)

func _process(_delta: float):
	Steam.run_callbacks()

@rpc("call_local", "any_peer")
func register_player(new_player_name: String):
	var id = multiplayer.get_remote_sender_id()
	players[id] = _make_string_unique(new_player_name)
	player_list_changed.emit()

func unregister_player(id):
	players.erase(id)
	player_list_changed.emit()

@rpc("call_local")
func load_world():
	var world = load("res://world.tscn").instantiate()
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("Lobby").hide()
	get_tree().set_pause(false)

func host_lobby(new_player_name: String):
	player_name = new_player_name
	players[1] = new_player_name
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, MAX_PEERS)

func join_lobby(new_lobby_id: int, new_player_name: String):
	player_name = new_player_name
	Steam.joinLobby(new_lobby_id)

func begin_game():
	assert(multiplayer.is_server())
	load_world.rpc()
	#var world = get_tree().get_root().get_node("World")
	#var player_scene = preload("res://scenes/Player/player.tscn")
	#var spawn_index = 0
	for peer_id in players:
		var pame = players[peer_id]
		spawn_player.rpc(peer_id, Vector3.ZERO, pame)
		#spawn_index += 1

@rpc("any_peer", "call_local")
func spawn_player(id: int, position: Vector3, new_name: String):
	var player_scene = preload("res://scenes/Player/player.tscn")
	var player = player_scene.instantiate()
	player.name = "Player" + str(id)
	player.position = position
	player.set_player_name(new_name)
	get_tree().get_root().get_node("World/Players").add_child(player)
	player.set_multiplayer_authority(id)

func create_steam_socket():
	peer = SteamMultiplayerPeer.new()
	peer.create_host(0, [])
	if peer:
		multiplayer.multiplayer_peer = peer

func connect_steam_socket(steam_id: int):
	peer = SteamMultiplayerPeer.new()
	peer.create_client(steam_id, 0, [])
	multiplayer.multiplayer_peer = peer

func create_enet_host(new_player_name: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT)
	player_name = new_player_name
	players[1] = new_player_name
	multiplayer.multiplayer_peer = peer

func create_enet_client(new_player_name: String, address: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, DEFAULT_PORT)
	multiplayer.multiplayer_peer = peer
	await multiplayer.connected_to_server
	register_player.rpc(new_player_name)
	players[multiplayer.get_unique_id()] = new_player_name

func _make_string_unique(query: String) -> String:
	var count := 2
	var trial := query
	while players.values().has(trial):
		trial = query + ' ' + str(count)
		count += 1
	return trial

@rpc("call_local", "any_peer")
func get_player_name() -> String:
	return players[multiplayer.get_remote_sender_id()]

func is_game_in_progress() -> bool:
	return has_node("/root/World")

func end_game():
	if is_game_in_progress():
		get_node("/root/World").queue_free()
	game_ended.emit()
	players.clear()

func _on_peer_connected(id: int):
	register_player.rpc_id(id, player_name)

func _on_peer_disconnected(id: int):
	if is_game_in_progress():
		if multiplayer.is_server():
			game_error.emit("Player " + players[id] + " disconnected")
			end_game()
	else:
		unregister_player(id)

func _on_connected_to_server():
	connection_succeeded.emit()

func _on_connection_failed():
	multiplayer.multiplayer_peer = null
	connection_failed.emit()

func _on_server_disconnected():
	game_error.emit("Server disconnected")
	end_game()

func _on_lobby_joined(new_lobby_id: int, _permissions: int, _locked: bool, response: int):
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		lobby_id = new_lobby_id
		var id = Steam.getLobbyOwner(new_lobby_id)
		if id != Steam.getSteamID():
			connect_steam_socket(id)
			register_player.rpc(player_name)
			players[multiplayer.get_unique_id()] = player_name
	else:
		var FAIL_REASON: String
		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST:
				FAIL_REASON = "This lobby no longer exists."
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED:
				FAIL_REASON = "You don't have permission to join this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL:
				FAIL_REASON = "The lobby is now full."
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR:
				FAIL_REASON = "Uh... something unexpected happened!"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED:
				FAIL_REASON = "You are banned from this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED:
				FAIL_REASON = "You cannot join due to having a limited account."
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED:
				FAIL_REASON = "This lobby is locked or disabled."
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN:
				FAIL_REASON = "This lobby is community locked."
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU:
				FAIL_REASON = "A user in the lobby has blocked you from joining."
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER:
				FAIL_REASON = "A user you have blocked is in the lobby."
		game_log.emit(FAIL_REASON)

func _on_lobby_created(status: int, new_lobby_id: int):
	if status == 1:
		Steam.setLobbyData(new_lobby_id, "name", Steam.getPersonaName() + "'s Fantasy Server")
		Steam.setLobbyData(new_lobby_id, "game", GAME_ID)
		create_steam_socket()
	else:
		game_error.emit("Error on create lobby!")
