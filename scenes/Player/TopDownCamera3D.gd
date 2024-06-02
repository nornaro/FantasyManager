extends Camera3D

const SPEED = 0.25

var scroll: Vector2
var scroll_speed = 10
var scroll_direction = 0
var input_dir = Vector2.ZERO
var run_speed = 3
var pos = Vector3.ZERO
var rot = Vector3.ZERO


func _ready() -> void:
	pos = position
	rot = rotation
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _process(delta: float) -> void:
	handle_camera(delta)
	handle_scroll(delta)
	#handle_wasd(delta)
	
func handle_camera(_delta):
	if Input.is_action_pressed("p_reset"):
		_on_position_reset_pressed()
	if Input.is_action_pressed("r_reset"):
		_on_rotation_reset_pressed()
	if Input.is_action_pressed("speed+"):
		scroll_speed += 0.1
	if Input.is_action_pressed("speed-"):
		scroll_speed -= 0.1
	if Input.is_action_pressed("camera_up"):
		position.y += scroll_speed
	if Input.is_action_pressed("camera_down"):
		position.y -= scroll_speed
	if Input.is_action_pressed("zoom+"):
		scroll_direction -= scroll_speed
	if Input.is_action_pressed("zoom-"):
		scroll_direction += scroll_speed
	if Input.is_action_just_pressed("cameratilt"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_released("cameratilt"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	if Input.is_action_pressed("cameratilt"):
		var camera_tilt := Input.get_last_mouse_velocity().normalized()
		rotation += Vector3(-camera_tilt.y/25,-camera_tilt.x/25,0)
		rotation.x = clamp(rotation.x,-1.5,0)	
		
		
func handle_scroll(delta):
	if scroll_direction != 0:
		position.y += scroll_speed * scroll_direction * delta
		scroll_direction -= scroll_speed * scroll_direction * delta
	position.y = clamp(position.y, 2, 1000)
	scroll_speed = clamp(scroll_speed, 0.0, 20)
	input_dir = Input.get_vector("a", "d", "w", "s")
	var run = run_speed
	if Input.is_action_pressed("run"):
		run = 1
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y) + transform.basis * Vector3(-scroll.y,0,scroll.x)).normalized()/run*sqrt(position.y)

	position += Vector3(direction.x,0,direction.z)

func _on_scroll_scroll(scroll_vector: Variant) -> void:
	scroll = scroll_vector
	

func _on_position_reset_pressed() -> void:
	position = pos


func _on_rotation_reset_pressed() -> void:
	rotation = rot
	
