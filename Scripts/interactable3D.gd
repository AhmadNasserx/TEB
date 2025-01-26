extends Area3D

@export var interaction_distance: float = 3.0
@export var interaction_message: String = "Press [E] to interact."

signal interacted

# The player or entity that can interact with this object
var player: Node3D = null

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	hide_interaction_prompt()

func _on_body_entered(body: Node):
	if body.has_method("is_player") and body.is_player():
		player = body
		show_interaction_prompt()

func _on_body_exited(body: Node):
	if body == player:
		player = null
		hide_interaction_prompt()

func _process(delta: float):
	if player and is_player_within_distance():
		if Input.is_action_just_pressed("interact"):  # Bind "interact" to your desired key in Input Map
			emit_signal("interacted")
			handle_interaction()
	elif player:
		hide_interaction_prompt()

func is_player_within_distance() -> bool:
	return global_transform.origin.distance_to(player.global_transform.origin) <= interaction_distance

func handle_interaction():
	print("Interacted with", self.name)

func show_interaction_prompt():
	# Implement your UI prompt logic here (e.g., call a UI manager to display the message)
	print(interaction_message)

func hide_interaction_prompt():
	# Hide the interaction prompt
	pass
