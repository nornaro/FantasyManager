extends Node3D

@export var server_address: String = "127.0.0.1"
@export var server_port: int = 12345

func _ready():
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(server_address, server_port)
	multiplayer.multiplayer_peer = peer
	print("Client connected")

@rpc("any_peer", "call_local")
func set_authority(id: int) -> void:
	multiplayer.set_multiplayer_authority(id)

@rpc("any_peer", "call_local")
func teleport(new_position: Vector3) -> void:
	self.position = new_position

func set_player_name(value: String):
	$Label.text = value

@rpc("any_peer", "call_local")
func spawn_player(id: int, new_position: Vector3, new_name: String):
	var player_scene = load("res://scenes/Player/player.tscn")
	var player = player_scene.instantiate()
	player.name = "Player" + str(id)
	player.position = new_position
	player.set_player_name(new_name)
	add_child(player)
	player.set_multiplayer_authority(id)
