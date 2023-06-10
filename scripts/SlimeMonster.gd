extends Monster

var targetPosition : Vector2
var jumpTween
var jumping = false
@onready var jumpFrequency = stats.slimeStats.jumpFrequency
@onready var rangeOfJump = stats.slimeStats.rangeOfJump

func _ready():
	idleAttack()

func idleAttack():
	await get_tree().create_timer(jumpFrequency).timeout
	jumpToPlayer()
	idleAttack()

func jumpToPlayer():
	jumping = true
	print("damage: ", stats.hp)
	
	navigationAgent.target_position = player.global_position #Seeking goal vector
	targetPosition = navigationAgent.get_next_path_position() 
	print(targetPosition)
	var direction = targetPosition - global_position
	direction = direction.normalized()
#	direction = normalizeJump(direction)
	
	#Calculating jump distance
	var goal = position + (direction * (rangeOfJump - randi()%(rangeOfJump/4)))
	
	#Animation jump
	var t = create_tween()
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property(self,"position",goal,0.5)
	t.tween_callback(endJump)
	var t1 = create_tween()
	t1.tween_property(self,"scale",Vector2(0.3,0.3),0.2)
	t1.tween_property(self,"scale",Vector2(0.2,0.2),0.3)
	t1.tween_property(self,"scale",Vector2(0.3,0.3),0.1)
	t1.tween_property(self,"scale",Vector2(0.2,0.2),0.1)
	jumpTween = t

func normalizeJump(direction): #Makes slime jump in x and y axis, so jumping is more unique
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
	jumping = false

func reciveDamageAnimation():
	super()
	if jumpTween:
		jumpTween.kill()
