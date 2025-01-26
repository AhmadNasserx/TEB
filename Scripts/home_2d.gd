extends Node2D
@onready var bg: ParallaxBackground = $BG


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Home2d.visible == false:
		bg.hide()
	else:
		bg.show()
