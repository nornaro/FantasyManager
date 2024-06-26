extends Node3D


@export var highlight_color: Color = Color(1, 1, 0) # Yellow
@export var normal_color: Color = Color(1, 1, 1) # White
@export var blink_frequency: float = 1.0 # Blinks per second

var pointover = "mousepointover"

func build(building: String) -> void:
	%ProtonScatter.hide()
	$BaseBody.input_ray_pickable = false
	$BaseBody.get_node("CollisionShape3D").disabled = false
	get_node(building).show()
	get_node(building).get_node("CollisionShape3D").disabled = false

var highlight_enabled = false
var highlight_time = 0.0

@onready var mesh_instance: MeshInstance3D # Adjust this path to your mesh instance

func _ready():
	set_process(false) # Disable process by default

func select():
	$Select.show()

func deselect():
	$Select.hide()

func highlight():
	for child in get_children():
		if child.visible:
			mesh_instance = child.get_node("MeshInstance3D")
	highlight_enabled = true
	highlight_time = 0.0
	set_process(true)

func stop_highlight():
	highlight_enabled = false
	mesh_instance.modulate = normal_color
	set_process(false)

func _process(delta):
	if highlight_enabled:
		highlight_time += delta
		var t = (sin(highlight_time * blink_frequency * PI * 2) + 1) / 2 # Normalized sine wave
		mesh_instance.modulate = normal_color.lerp(highlight_color, t)
		
