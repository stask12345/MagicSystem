extends Monster

@export var speed = 250
var targetPosition : Vector2
var following = false

func startFollowing(): #attack loop
	if !following:
		following = true
		followPlayer()
		await get_tree().create_timer(0.2).timeout
		following = false
		if velocity != Vector2(0,0):
			startFollowing()

#func startLosingFollow():
#	timer.stop()
#	timer.wait_time = 0.5
#	timer.start()

func followPlayer(): #updates player position
	navigationAgent.target_position = player.global_position #Seeking goal vector
	targetPosition = navigationAgent.get_next_path_position()
	var direction = targetPosition - global_position
	direction = direction.normalized()
	var movement = direction * speed
	velocity = movement

func gainTrigger():
	super()
	timer.stop()
	startFollowing()

func loseTrigger():
	super()
	velocity = Vector2(0,0)

func reciveDamageAnimation():
	super()
	gainTrigger()
	timer.stop()
	timer.wait_time = agressionTime*2
	timer.start()
