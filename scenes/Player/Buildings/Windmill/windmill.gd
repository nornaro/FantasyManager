extends Node3D


@onready var bot = $BuildingWindmillBlue
@onready var top = $BuildingWindmillTopBlue
@onready var wheel = $Axis/BuildingWindmillBlueBuildingWindmillTopBlueBuildingWindmillTopFanBlue

func _process(delta: float) -> void:
	if !$"..".visible:
		return
	if bot.position.y < 0:
		bot.position.y += delta
		return
	if top.position.y < 0:
		top.position.y += delta
		return
	if wheel.scale.y < 1:
		wheel.scale += Vector3(delta,delta,delta)
		return
		
	%Axis.rotation.z -= delta/2
	if %Axis.rotation.z < 360:
		%Axis.rotation.z += 360
