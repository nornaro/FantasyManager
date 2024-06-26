extends Node3D

@export var player_id := 1:
	set(id):
		player_id = id
		%MultiplayerSynchronizer.set_multiplayer_authority(id, true)
		GlobalMultiplayerSynchronizer.set_multiplayer_authority(id, true)

#
#func _ready():
	#var peer := ENetMultiplayerPeer.new()
	#peer.create_client(server_address, server_port)
	#multiplayer.multiplayer_peer = peer
	#set_score()
	#set_score.rpc()
	#set_score.rpc_id(multiplayer.get_unique_id())
#
#@rpc("any_peer")
#func set_score():
	#score[multiplayer.get_unique_id()] = 0
	#Autoload.player_labels[multiplayer.get_unique_id()] = 0
	#print(score)
	#print(Autoload.player_labels)
	#
	#

	#score = multiplayer.get_unique_id()
#	multiplayer.set_multiplayer_authority(multiplayer.get_unique_id())
#
#@rpc("any_peer", "call_local")
#func set_authority(id: int) -> void:
	#print(id)
	#multiplayer.set_multiplayer_authority(id)
#
#@rpc("any_peer", "call_local")
#func teleport(new_position: Vector3) -> void:
	#self.position = new_position
#
#@rpc("any_peer", "call_local")
#func set_player_name(_value: String):
	#print(Autoload.player_labels)
#
#@rpc("any_peer", "call_local")
#func spawn_player(id: int, new_position: Vector3, new_name: String):
	#var player_scene = load("res://scenes/Player/player.tscn")
	#var player = player_scene.instantiate()
	#player.name = str(id)
	#print(id)
	#player.position = new_position
	#player.set_player_name(new_name)
	#add_child(player)
	#player.set_multiplayer_authority(id)
