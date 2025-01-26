extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area_2d: Area2D = $detectionArea2D
@onready var bubble_animation_player: AnimationPlayer = $bubbleAnimationPlayer
var in2Dscene: bool = true
# Speed of the character
@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	# Handle movement input
	var input_vector: Vector2 = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	# Move the character
	velocity = input_vector * speed
	if Home2d.is_visible_in_tree():
		move_and_slide()

	# Update animation and detection area rotation
	_update_animation(input_vector)
	_update_detection_area(input_vector)
	if Input.is_action_just_pressed("shift") and in2Dscene:
		bubble_animation_player.play("bubble_transfer")
		in2Dscene = false
		await SceneManager.change_scene(str(Level.get_path()))
		Level.show()
		Home2d.hide()
	elif Input.is_action_just_pressed("shift") and !in2Dscene:
		bubble_animation_player.play("bubble_return")
		in2Dscene = true


func _update_animation(input_vector: Vector2) -> void:
	var current_animation: String = str(animated_sprite_2d.animation)

	if input_vector == Vector2.ZERO:
		# No movement: Set idle animations
		if current_animation.begins_with("walk"):
			animated_sprite_2d.animation = current_animation.replace("walk", "idle")
			animated_sprite_2d.play()  # Start playing the idle animation
	else:
		# Determine the animation based on movement direction
		var new_animation = "walk"

		if abs(input_vector.x) > abs(input_vector.y):
			# Horizontal movement is stronger
			new_animation += "_right_down" if input_vector.x > 0 else "_left_down"
		else:
			# Vertical movement is stronger
			if input_vector.y > 0:
				new_animation += "_down"
			else:
				# Upward movement
				new_animation += "_left_up" if input_vector.x < 0 else "_right_up"

		# Only change the animation if it's different
		if current_animation != new_animation:
			animated_sprite_2d.animation = new_animation
			animated_sprite_2d.play()  # Start playing the walk animation

func _update_detection_area(input_vector: Vector2) -> void:
	# Rotate the detection area based on movement direction
	if input_vector != Vector2.ZERO:
		detection_area_2d.rotation = input_vector.angle()
