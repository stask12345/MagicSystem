extends Node2D

@export var barScale : float = 1

func _ready():
	scaleHealthBar()

func scaleHealthBar():
	$Background.scale = Vector2($Background.scale.x * barScale, $Background.scale.y)
	$Health.scale = Vector2($Health.scale.x * barScale, $Health.scale.y)
