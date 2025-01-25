extends Node

@export var home_scene_path: String = "res://Scenes/2D/home_2d.tscn"  # Path to Home2d
@export var level_scene_path: String = "res://Scenes/3D/level.tscn"   # Path to Level

func _change_scene() -> void:
	# Get the current active scene's name (not the path)
	var current_scene_name = get_tree().current_scene.name
	print("Current scene name: ", current_scene_name)  # Debugging line to print the current scene's name

	# Determine the next scene's path based on the current scene's name
	# If we're in Home, go to Level; if we're in Level, go to Home.
	if current_scene_name == "Home2d":
		get_tree().change_scene_to_file(level_scene_path)
	elif current_scene_name == "Level":
		get_tree().change_scene_to_file(home_scene_path)
