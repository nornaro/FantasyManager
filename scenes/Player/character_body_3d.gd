extends CharacterBody3D


var SPEED = 25.0
const JUMP_VELOCITY = 45


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta*5

	# Handle jump.
	
	if Input.is_action_pressed("up"):
		velocity.y += delta
	
	if Input.is_action_pressed("down"):
		velocity.y -= delta
		
	if Input.is_action_pressed("run"):
		SPEED  = 50

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_pressed("ui_right"):
		rotation.y -= delta * 3

	if Input.is_action_pressed("ui_left"):
		rotation.y += delta * 3

	move_and_slide()
