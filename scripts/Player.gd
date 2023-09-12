extends CharacterBody2D

@onready var joystick = %Joystick
var speed = 100000
var previousMotion = Vector2(0,0) #dla animatePlayer
var canMakeDust = true
var dustFrame = 0
@onready var character : Character = get_node("Character")
var knockback : Vector2 = Vector2(0,0)

func _ready():
	var shaders = preload("res://objects/ShaderPreload.tscn").instantiate() #preloading shaders
	add_child(shaders)

func _physics_process(delta):
	var motion = joystick.get_value()
	animatePlayer(motion)
	velocity = motion * speed * delta
	if knockback != Vector2(0,0):
		velocity = knockback
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

func makeDust(): #running effect
	canMakeDust = false
	var d = preload("res://objects/utility/DustRunningEffect.tscn").instantiate()
	d.frame = dustFrame
	dustFrame += 1
	if dustFrame == 3:
		dustFrame = 0
	d.position = position
	d.position = Vector2(d.position.x, d.position.y + 8)
	get_node("/root/MainScene/Game").add_child(d)
	await get_tree().create_timer(0.2).timeout
	canMakeDust = true

func slowlyFall(): #for animation purposes when player spawn
	visible = true
	%Camera.position_smoothing_enabled = true
	%Camera.limit_smoothed = true
	$AnimationPlayer.play("spawnPlayer")
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(self,"position",Vector2(position.x,position.y + 10),1)
	t.parallel().tween_property($Camera,"zoom",Vector2(1.3,1.3),1)

func endFall(): #for spawn animation
	$Character/AnimationPlayer.play("idleDown")
	$WeponHolder.visible = true
