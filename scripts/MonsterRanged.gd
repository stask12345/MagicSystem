extends Monster

@export var speed = 250
@export var shootingSpeed : float = 1
@export var bullet : PackedScene
var targetPosition : Vector2
var inShootingRange = false
var isDoingAction = false

func _ready():
	super()
	$RangedArea.connect("area_shape_entered",enteredShootingRange)
	$RangedArea.connect("area_shape_exited",exitedShootingRange)

func startAction(): #attack loop
	if !isDoingAction and agressive and stats.hp > 0:
		isDoingAction = true
		if advancedAnimation:
			if global_position.x - player.global_position.x > 0:
				$Sprite2D.scale.x = 1
			else:
				$Sprite2D.scale.x = -1
		
		if inShootingRange and alive: #shooting
			velocity = Vector2(0,0)
			$AnimationPlayer.play("shooting")
			await get_tree().create_timer(shootingSpeed).timeout
			isDoingAction = false
			startAction()
		else:
			followPlayer() #following
			if alive: $AnimationPlayer.play("running")
			await get_tree().create_timer(0.2).timeout
			isDoingAction = false
			if velocity != Vector2(0,0):
				startAction()
	if !agressive:
		if alive: $AnimationPlayer.play("idle")

func followPlayer(): #updates player position
	navigationAgent.target_position = player.global_position #Seeking goal vector
	targetPosition = navigationAgent.get_next_path_position()
	var direction = targetPosition - global_position
	direction = direction.normalized()
	var movement = direction * speed
	velocity = movement

func shoot():
	var b : BulletMonster = bullet.instantiate()
	$ParticlesShoot.emitting = true
	b.damage = stats.damage
	get_parent().add_child(b)
	b.global_position = global_position
	b.look_at(player.global_position)
	b.speed += 200

func gainTrigger():
	super()
	timer.stop()
	startAction()

func loseTrigger():
	super()
	velocity = Vector2(0,0)

func enteredShootingRange(_area_rid, area, _area_shape_index, _local_shape_index):
	inShootingRange = true

func exitedShootingRange(_area_rid, area, _area_shape_index, _local_shape_index):
	inShootingRange = false

func reciveDamageAnimation():
	super()
	gainTrigger()
	timer.stop()
	timer.wait_time = agressionTime*2
	timer.start()
