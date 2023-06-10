extends CharacterBody2D

@onready var joystick = %Joystick
var speed = 100000
var previousMotion = Vector2(0,0) #dla animatePlayer
var canMakeDust = true
var dustFrame = 0
@onready var character : Character = get_node("Character")

func _ready():
	var shaders = preload("res://objects/ShaderPreload.tscn").instantiate()
	add_child(shaders)

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
				$Character.scale.x = 1
			else:
				$Character.scale.x = -1
			$Character/AnimationPlayer.current_animation = "runningSide"
		else:
			if motion.y > 0:
				$Character/AnimationPlayer.play("runningDown")
			else:
				$Character/AnimationPlayer.play("runningUp")
		if canMakeDust:
			if motion.x > 0.15 or motion.y > 0.15 or motion.x < -0.15 or motion.y < -0.15:
				makeDust()
	else:
		if abs(previousMotion.x) > abs(previousMotion.y):
			if previousMotion.x > 0:
				$Character.scale.x = 1
			else:
				$Character.scale.x = -1
			$Character/AnimationPlayer.play("idleSide")
		else:
			if previousMotion.y > 0:
				$Character/AnimationPlayer.play("idleDown")
			if previousMotion.y < 0:
				$Character/AnimationPlayer.play("idleUp")
	previousMotion = motion

func makeDust():
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
