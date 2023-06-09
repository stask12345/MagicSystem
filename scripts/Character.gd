extends Sprite2D
class_name Character

@export var stats : CharacterStats = CharacterStats.new()
@onready var hp := stats.totalHp
@onready var heartsMenu := %LeftTop

func getDamage(damage : int, hitPoint):
	hp -= damage
	
	$"../DamageParticles".emitting = true
	$"../DamageParticles2".emitting = true
	var t = create_tween()
	t.set_trans(Tween.TRANS_CIRC)
	t.tween_property(self,"self_modulate",Color(5,5,5),0.1)
	t.tween_property(self,"self_modulate",Color(1,1,1),0.1)
	%Camera.shake(8,8)
	knock(hitPoint, 0.5)
	
	heartsMenu.updateHearts()
	$"../CharacterBody/CollisionShape2D".set_deferred("disabled",true)
	await get_tree().create_timer(0.6).timeout
	$"../CharacterBody/CollisionShape2D".set_deferred("disabled",false)

var knockBackTween
func knock(point, power, time = 0.1):
	var direction =  point - global_position
	direction = -direction
	direction.normalized()
	
	var goal = global_position + (direction * power)
	
	if knockBackTween:
		knockBackTween.kill()
	knockBackTween = create_tween()
	knockBackTween.set_trans(Tween.TRANS_SINE)
	knockBackTween.tween_property(get_parent(),"global_position",goal,time)

func _on_character_body_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var e = area.get_parent()
	if e is Monster:
		var monster : Monster = e
		getDamage(e.stats.damage, e.global_position)
