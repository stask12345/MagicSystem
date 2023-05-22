extends CharacterBody2D

@onready var joystick = %Joystick
var speed = 100000
var previousMotion = Vector2(0,0) #dla animatePlayer

func _process(delta):
	var motion = joystick.get_value()
	animatePlayer(motion)
	velocity.x = motion.x * speed * delta
	velocity.y = motion.y * speed * delta
	move_and_slide()

func animatePlayer(motion):
	if motion.x != 0 and motion.y != 0:
		if abs(motion.x) > abs(motion.y):
			if motion.x > 0: 
				$Player.scale.x = 1
			else:
				$Player.scale.x = -1
			$Player/AnimationPlayer.current_animation = "runningSide"
		else:
			if motion.y > 0:
				$Player/AnimationPlayer.play("runningDown")
			else:
				$Player/AnimationPlayer.play("runningUp")
	else:
		if abs(previousMotion.x) > abs(previousMotion.y):
			if previousMotion.x > 0:
				$Player.scale.x = 1
			else:
				$Player.scale.x = -1
			$Player/AnimationPlayer.play("idleSide")
		else:
			if previousMotion.y > 0:
				$Player/AnimationPlayer.play("idleDown")
			if previousMotion.y < 0:
				$Player/AnimationPlayer.play("idleUp")
	previousMotion = motion
