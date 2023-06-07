extends Node2D
class_name Monster
@export var stats : Resource
@onready var maxHp = stats.hp
@onready var player = %Player
@onready var hpBar = $HPBar

func reciveDamage(damage):
	stats.hp -= damage
	hpBar.updateHealthBar(stats.hp, maxHp)
	reciveDamageAnimation()
	if stats.hp <= 0:
		$AnimationPlayer.play("death")

func reciveDamageAnimation():
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self,"self_modulate",Color(4,4,4),0.1)
	t.tween_property(self,"self_modulate",Color(1,1,1),0.1)

var knockBackTween
func knock(point, power, time = 0.1):
	var direction =  point - position
	direction = -direction
	direction.normalized()
	
	var distance = position.distance_to(point)
	var percentRange = power/distance
	
	var goal = position + (direction * percentRange)
	
	if knockBackTween:
		knockBackTween.kill()
	knockBackTween = create_tween()
	knockBackTween.set_trans(Tween.TRANS_SINE)
	knockBackTween.tween_property(self,"position",goal,time)
