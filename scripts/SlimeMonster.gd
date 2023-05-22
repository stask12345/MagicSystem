extends Monster

var playerPosition : Vector2
var rangeOfJump = 40

func _ready():
	idleAttack()
	pass

func idleAttack():
	await get_tree().create_timer(2).timeout
	jumpToPlayer()
	idleAttack()

func jumpToPlayer():
	playerPosition = player.position
	var direction = playerPosition - position
	direction.normalized()
	var distance = position.distance_to(playerPosition)
	var percentRange = rangeOfJump/distance
	var goal = position + (direction * percentRange)
	var t = create_tween()
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property(self,"position",goal,0.5)
	var t1 = create_tween()
	t1.tween_property(self,"scale",Vector2(0.3,0.3),0.2)
	t1.tween_property(self,"scale",Vector2(0.2,0.2),0.3)
	t1.tween_property(self,"scale",Vector2(0.3,0.3),0.1)
	t1.tween_property(self,"scale",Vector2(0.2,0.2),0.1)
