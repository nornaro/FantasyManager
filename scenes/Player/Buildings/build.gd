extends Node

@onready var bot: MeshInstance3D
@onready var top: MeshInstance3D
@onready var axis: MeshInstance3D
@onready var wheel: MeshInstance3D
@onready var basebody = $"../../BaseBody"

func _ready() -> void:
	bot = get_node_or_null("bot")
	top = get_node_or_null("top")
	axis = get_node_or_null("axis")
	wheel = get_node_or_null("axis/wheel")

func _process(delta: float) -> void:
	if !$"..".visible:
		return
	if bot && bot.position.y < 0:
		bot.position.y += delta
		return
	if top  && top.position.y < 0:
		top.position.y += delta
		return
	if axis  && axis.position.y < 0:
		axis.position.y += delta
		return
	if wheel  && wheel.scale.y < 1:
		wheel.scale += Vector3(delta,delta,delta)
		return
	if basebody.position.y > -1:
		basebody.position.y -= delta
		return
	basebody.hide()
	#axis.rotation.z -= delta/2
	#if axis.rotation.z < 360:
		#axis.rotation.z += 360
