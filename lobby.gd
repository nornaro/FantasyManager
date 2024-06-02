extends Control

@export var persona_name : Label
@export var player_name : LineEdit
@export var error_label : Label
@export var host : Button
@export var address : LineEdit
@export var lobby_container : ItemList
@export var steam_connect : Control
@export var steam_players : Control

@export var enet_address_entry : LineEdit
@export var enet_start_button : Button

@onready var lobby_name: ItemList = %LobbyName
@onready var players: ItemList = %Players
@onready var id: ItemList = %ID
@onready var lobby_id: LineEdit  = %LobbyId

signal game_log(what : String)

func _ready():
	persona_name.text = Steam.getPersonaName()
	
	# Called every time the node is added to the scene.
	gamestate.connection_failed.connect(self._on_connection_failed)
	gamestate.connection_succeeded.connect(self._on_connection_success)
	gamestate.player_list_changed.connect(self.refresh_lobby)
	gamestate.game_ended.connect(self._on_game_ended)
	gamestate.game_error.connect(self._on_game_error)
	gamestate.game_log.connect(self._on_game_log)
	
	# Set player name to Steam username.
	player_name.text = Steam.getPersonaName()
	
	game_log.connect(self._on_game_log)
	
	_setup_ui()

func _setup_ui():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	Steam.lobby_match_list.connect(fill_loby_menu)
	_request_lobby_list()

func fill_loby_menu(lobbies : Array):
	for sample in lobbies:
		if ( lobby_id.text != "" &&
			!(str(sample).contains(lobby_id.text) ||
			  str(Steam.getLobbyData(sample, "name")).contains(lobby_id.text))
		):
			return
		lobby_name.add_item(" "+Steam.getLobbyData(sample, "name"))
		players.add_item(" "+str(Steam.getNumLobbyMembers(sample)),null, false)
		id.add_item(str(sample),null,false)

func _request_lobby_list():
	Steam.addRequestLobbyListStringFilter("game", gamestate.GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)
	#Steam.addRequestLobbyListStringFilter("name",lobby_id.text,Steam.LOBBY_COMPARISON_EQUAL_TO_OR_LESS_THAN)
	
	lobby_name.clear()
	players.clear()
	id.clear()
	
	Steam.requestLobbyList()

func _on_host_pressed():
	steam_connect.hide()
	steam_players.show()
	gamestate.host_lobby(player_name.text)
	refresh_lobby()

func _on_connection_success():
	steam_connect.hide()
	steam_players.show()


func _on_connection_failed():
	host.disabled = false
	error_label.set_text("Connection failed.")


func _on_game_ended():
	show()
	steam_connect.show()
	steam_players.hide()
	host.disabled = false


func _on_game_error(errtxt : String):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered()
	host.disabled = false

func _on_game_log(logtxt : String):
	print(logtxt)


func refresh_lobby():
	var players_list = gamestate.players.values()
	players_list.sort()
	%SteamList.clear()
	for sample_name in players_list:
		%SteamList.add_item(
			sample_name if 
				sample_name != gamestate.player_name else 
				(sample_name + " (You)")
		)
	
	%SteamStart.disabled = not multiplayer.is_server()
	#Ensure we have an actual lobby ID before continuing
	await Steam.lobby_joined
	%SteamLobbyID.text = str(gamestate.lobby_id)
	
	_request_lobby_list()
	
func _on_start_pressed():
	gamestate.begin_game()

func _on_enet_host_pressed():
	gamestate.create_enet_host(player_name.text)
	
	#Issue: player isn't being added to `players` list
	enet_start_button.disabled = false

func _on_enet_join_pressed():
	gamestate.player_name = player_name.text
	gamestate.create_enet_client(
		gamestate.player_name,
		"127.0.0.1" if enet_address_entry.text.is_empty()
		else enet_address_entry.text)


func _on_lobby_name_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	%Connect.hide()
	$TabContainer/Steam/Players.show()
	gamestate.join_lobby(
		int(%ID.get_item_text(index)),
		player_name.text)


func _on_join_pressed() -> void:
	if lobby_name.get_selected_items().is_empty():
		return
	var index:int =	lobby_name.get_selected_items()[0]
	steam_connect.hide()
	steam_players.show()
	gamestate.join_lobby(int(id.get_item_text(index)), gamestate.player_name)


func _on_back_pressed() -> void:
	gamestate.end_game()
	pass # Replace with function body.


func _on_lobby_id_text_submitted(_new_text: String) -> void:
	_request_lobby_list()
	
func _on_id_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	DisplayServer.clipboard_set(%ID.get_item_text(index))


func _on_lobby_name_item_activated(_index: int) -> void:
	_on_join_pressed()


func _on_steam_kick_pressed() -> void:
	gamestate.game_error.emit("Server disconnected")
	gamestate.end_game()
	pass # Replace with function body.


func _on_lobby_id_text_changed(_new_text: String) -> void:
	_request_lobby_list()
