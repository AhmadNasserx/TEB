extends Node2D
@onready var bg: ParallaxBackground = $BG
@onready var pi_m_ref: CanvasLayer = $"PiM ref"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pi_m_ref.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Home2d.visible == false:
		bg.hide()
	else:
		bg.show()
