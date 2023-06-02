extends Monster

var playerPosition : Vector2
var rangeOfJump = 40
var jumpTween
var jumping = false

func _ready():
	idleAttack()
	pass

func idleAttack():
	await get_tree().create_timer(2).timeout
	jumpToPlayer()
	idleAttack()

func jumpToPlayer():
	jumping = true
	playerPosition = player.position
	var direction = playerPosition - position
	direction.normalized()
	var distance = position.distance_to(playerPosition)
	var percentRange = rangeOfJump/distance
	var goal = position + (direction * percentRange)
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

func endJump():
	jumping = false

func reciveDamageAnimation():
	super()
	if jumpTween:
		jumpTween.kill()
	if jumping:
		knock(playerPosition,20)
	else:
		knock(playerPosition,10)
