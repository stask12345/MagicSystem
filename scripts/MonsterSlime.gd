extends Monster
class_name MonsterSlime

var targetPosition : Vector2
var jumping = false
@onready var jumpFrequency = stats.slimeStats.jumpFrequency
@onready var rangeOfJump = stats.slimeStats.rangeOfJump
@export var jumpPower = 400
@export var shootingJump = false
@export var bullet : PackedScene
@export var particlesColor : Color = Color.WHITE

func idleAttack():
	if agressive and !jumping:
		jumping = true
		await get_tree().create_timer(jumpFrequency).timeout
		jumpToPlayer()

var currentScale = scale
var nextScale = scale * 1.5
var jumpDirection = Vector2(0,0)
func jumpToPlayer():
	if advancedAnimation:
		$AnimationPlayer.play("preparing")
		await get_tree().create_timer(1).timeout
		$AnimationPlayer.play("jumping")
	
	navigationAgent.target_position = player.global_position #Seeking goal vector
	targetPosition = navigationAgent.get_next_path_position()
	var direction = targetPosition - global_position
	direction = direction.normalized()
	
	var t1 = create_tween()
	t1.tween_property($Sprite2D,"scale",nextScale,0.2)
	t1.tween_property($Sprite2D,"scale",currentScale,0.3)
	t1.tween_property($Sprite2D,"scale",nextScale,0.1)
	t1.tween_property($Sprite2D,"scale",currentScale,0.1)
	
	jumpDirection = direction * jumpPower
	velocity += jumpDirection
	await get_tree().create_timer(rangeOfJump).timeout
	endJump()

func normalizeJump(direction): #I'm currently not using it #Makes slime jump in x and y axis, so jumping is more unique 
	if direction.x > 0.9 and direction.y < 0.7 and direction.y > -0.7:
		direction = Vector2(1,0)
	if direction.x < -0.9  and direction.y < 0.7 and direction.y > -0.7:
		direction = Vector2(-1,0)
	if direction.y > 0.9 and direction.x < 0.7 and direction.x > -0.7:
		direction = Vector2(0,1)
	if direction.y < -0.9 and direction.x < 0.7 and direction.x > -0.7:
		direction = Vector2(0,-1)
	return direction

func endJump():
	if advancedAnimation:
		$AnimationPlayer.play("idle")
	$ParticlesShoot.color = particlesColor
	$ParticlesShoot.emitting = true
#	velocity -= jumpDirection
	velocity = Vector2(0,0)
	jumping = false
	if shootingJump:
		shoot()
	idleAttack()

func reciveDamageAnimation():
	super()
	#velocity = Vector2(0,0)
	gainTrigger()
	timer.stop()
	timer.wait_time = agressionTime*2
	timer.start()

func gainTrigger():
	super()
	if !jumping:
		idleAttack()

func shoot():
	for i in 8:
		var b : BulletMonster = bullet.instantiate()
		b.monster = self
		get_parent().add_child(b)
		b.global_position = global_position
		b.rotation_degrees = i * 45
