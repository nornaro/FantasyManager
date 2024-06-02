extends Node3D

func _process(delta: float) -> void:
	if !$"..".visible:
		return
	if %bot.position.y < 0:
		%bot.position.y += delta
		return
	if %top.position.y < 0:
		%top.position.y += delta
		return
	if %axis.position.y < 0:
		%axis.position.y += delta
		return
	if %wheel.scale.y < 1:
		%wheel.scale += Vector3(delta,delta,delta)
		return
	%axis.rotation.z -= delta/2
	if %axis.rotation.z < 360:
		%axis.rotation.z += 360
