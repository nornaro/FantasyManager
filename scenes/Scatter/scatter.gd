extends Node3D

var grass = preload("res://scenes/Scatter/grass.tscn")
var cache = preload("res://scenes/Scatter/scatter_cache.tscn")
var areas = [
	Vector3(-400,0,-300), Vector3(-400,0,-100), Vector3(-400,0,100), Vector3(-400,0,300),
	Vector3(-200,0,-300), Vector3(-200,0,-100), Vector3(-200,0,100), Vector3(-200,0,300),
	Vector3(0,0,-300), Vector3(0,0,-100), Vector3(0,0,100), Vector3(0,0,300),
	Vector3(200,0,-300), Vector3(200,0,-100), Vector3(200,0,100), Vector3(200,0,300),
	Vector3(400,0,-300), Vector3(400,0,-100), Vector3(400,0,100), Vector3(400,0,300),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for area in areas:
		var instance = grass.instantiate()
		instance.name = str(area)
		instance.position = area
		add_child(instance)
	$ScatterCache.update_cache()
		
	#var children = get_children()
	#for child in children:
		#var cache = child.get_node("ScatterCache")
		#if cache:
			#cache.cache_file = load("res://addons/proton_scatter/cache/"+child.name+"_scatter_cache.res")
	#
	pass # Replace with function body.
