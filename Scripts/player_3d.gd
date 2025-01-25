extends CharacterBody3D
@onready var head: Node3D = $Head

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.005  # Sensitivity for both axes

var pitch: float = 0.0  # To track the vertical (pitch) rotation

func _ready() -> void:
	# Hide the mouse cursor and capture it
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Call the function to control the head rotation
		control_head(event.relative)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shift"):
		SceneManager._change_scene()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func control_head(mouse_delta: Vector2) -> void:
	# Rotate the CharacterBody3D (yaw) using the mouse's X movement
	rotation.y -= mouse_delta.x * MOUSE_SENSITIVITY

	# Adjust the pitch (vertical rotation)
	pitch -= mouse_delta.y * MOUSE_SENSITIVITY
	pitch = clamp(pitch, deg_to_rad(-75), deg_to_rad(75))  # Clamp pitch to avoid extreme angles

	# Apply the clamped pitch to the head's rotation
	head.rotation.x = pitch
