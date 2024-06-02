class_name Rock
extends CharacterBody3D

@rpc("any_peer", "call_local")
func exploded(by_who : int):
	$"../../Score".increase_score(by_who)
	$"AnimationPlayer".play("explode")
