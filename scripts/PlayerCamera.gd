extends Camera2D

@export var shakeDecayRate : float = 5

var shaking = false
var shakeStrength : float = 0

func _process(delta):
	if shaking:
		shakeStrength = lerpf(shakeStrength, 0, shakeDecayRate * delta)
		
		offset = GetRandomOffset()
		if shakeStrength < 1:
			shaking = false

func shake(strength, decay):
	shakeStrength = strength
	shakeDecayRate = decay
	shaking = true

func GetRandomOffset():
	return Vector2(
		randf_range(-shakeStrength, shakeStrength),
		randf_range(-shakeStrength, shakeStrength)
	)
