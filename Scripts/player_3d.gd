extends CharacterBody3D
@onready var head: Node3D = $Head

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.005  # Sensitivity for both axes
const JOYSTICK_SENSITIVITY = 0.05  # Sensitivity for joystick movement

var pitch: float = 0.0  # To track the vertical (pitch) rotation
var yaw_delta: float = 0.0  # Tracks horizontal rotation from the joystick
var pitch_delta: float = 0.0  # Tracks vertical rotation from the joystick

func _ready() -> void:
	# Hide the mouse cursor and capture it
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if Level.is_visible_in_tree():
		if event is InputEventMouseMotion:
			# Control the head rotation with mouse movement
			control_head(event.relative.x * MOUSE_SENSITIVITY, event.relative.y * MOUSE_SENSITIVITY)
		elif event is InputEventJoypadMotion:
			# Handle joystick input for head movement
			if event.axis == JOY_AXIS_RIGHT_X:
				yaw_delta = event.axis_value * JOYSTICK_SENSITIVITY
			elif event.axis == JOY_AXIS_RIGHT_Y:
				pitch_delta = event.axis_value * JOYSTICK_SENSITIVITY

func _physics_process(delta: float) -> void:
	if  Level.is_visible_in_tree():
		if Input.is_action_just_pressed("shift"):
			await SceneManager.change_scene(str(Home2d.get_path()))
			Level.hide()
			Home2d.show()

	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and Level.is_visible_in_tree():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement/deceleration
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Apply joystick rotation smoothly
	control_head(yaw_delta, pitch_delta)
	if Level.is_visible_in_tree():
		move_and_slide()

func control_head(delta_x: float, delta_y: float) -> void:
	# Rotate the CharacterBody3D (yaw) using the horizontal movement
	rotation.y -= delta_x

	# Adjust the pitch (vertical rotation)
	pitch -= delta_y
	pitch = clamp(pitch, deg_to_rad(-75), deg_to_rad(75))  # Clamp pitch to avoid extreme angles

	# Apply the clamped pitch to the head's rotation
	head.rotation.x = pitch
