extends Node3D


@onready var bot = %BuildingWatermillRed
@onready var wheel = %BuildingWatermillRedBuildingWatermillWheelRed

func _process(delta: float) -> void:
	if !$"..".visible:
		return
	if bot.position.y < 0:
		bot.position.y += delta
		return
	if %Axis.position.y < 0:
		%Axis.position.y += delta
		return
	if wheel.scale.y < 1:
		wheel.scale += Vector3(delta,delta,delta)
		return
	%Axis.rotation.z -= delta
