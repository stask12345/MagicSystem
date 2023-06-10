extends CharacterBody2D
class_name Monster
@export var stats : MonsterStats
@onready var maxHp = stats.hp
@onready var player = %Player
@onready var hpBar = $HPBar
@onready var navigationAgent := $NavigationAgent2D

func reciveDamage(damage, hitPosition):
	stats.hp -= damage
	hpBar.updateHealthBar(stats.hp, maxHp)
	reciveDamageAnimation()
	knock(hitPosition,3)
	if stats.hp <= 0:
		colorTween.kill()
		$AnimationPlayer.play("death")

var colorTween
func reciveDamageAnimation():
	var t = get_tree().create_tween()
	colorTween = t
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property($Sprite2D,"self_modulate",Color(4,4,4),0.1)
	t.tween_property($Sprite2D,"self_modulate",Color(1,1,1),0.1)

var knockBackTween
func knock(point, power, time = 0.1):
	var direction =  point - global_position
	direction = -direction
	direction.normalized()
	
#	var distance = position.distance_to(point)
#	var percentRange = power/distance
	
	var goal = global_position + (direction * power)
	
	if knockBackTween:
		knockBackTween.kill()
	knockBackTween = create_tween()
	knockBackTween.set_trans(Tween.TRANS_SINE)
	knockBackTween.tween_property(self,"global_position",goal,time)
