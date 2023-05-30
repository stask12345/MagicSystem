extends CharacterBody2D

@onready var joystick = %Joystick
var speed = 100000
var previousMotion = Vector2(0,0) #dla animatePlayer
var canMakeDust = true
var dustFrame = 0

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
		if canMakeDust:
			if motion.x > 0.15 or motion.y > 0.15 or motion.x < -0.15 or motion.y < -0.15:
				makeDust()
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

func makeDust():
	print("1")
	canMakeDust = false
	var d = preload("res://objects/DustRunningEffect.tscn").instantiate()
	d.frame = dustFrame
	dustFrame += 1
	if dustFrame == 3:
		dustFrame = 0
	d.position = position
	d.position = Vector2(d.position.x, d.position.y + 8)
	get_node("/root/MainScene").add_child(d)
	await get_tree().create_timer(0.2).timeout
	canMakeDust = true
