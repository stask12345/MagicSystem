extends Node2D

@export var barScale : float = 1
var barStartScale : float

func _ready():
	scaleHealthBar()

func scaleHealthBar():
	$Background.scale = Vector2($Background.scale.x * barScale, $Background.scale.y)
	$Health.scale = Vector2($Health.scale.x * barScale, $Health.scale.y)
	$HealthWhite.scale = Vector2($HealthWhite.scale.x * barScale, $HealthWhite.scale.y)
	
	barStartScale = $Health.scale.x
	
	$Health.offset = Vector2(0.5,0)
	$Health.position = Vector2($Health.position.x - (barStartScale/2) ,$Health.position.y)
	$HealthWhite.offset = Vector2(0.5,0)
	$HealthWhite.position = Vector2($HealthWhite.position.x - (barStartScale/2) ,$HealthWhite.position.y)

func updateHealthBar(currentValue : float, maxValue : float):
	var fillLevelPercent : float = currentValue / maxValue
	var fillLevel = barStartScale * fillLevelPercent
	$Health.scale = Vector2(fillLevel,$Health.scale.y)
	
	var t = get_tree().create_tween()
	t.tween_property($HealthWhite,"scale",Vector2(fillLevel, $HealthWhite.scale.y),0.3)
	
	if currentValue < 0:
		visible = false
