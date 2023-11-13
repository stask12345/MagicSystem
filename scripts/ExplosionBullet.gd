extends Bullet

func _ready():
	super()
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property($Sprite2D,"rotation_degrees",rotation_degrees+100,currentWand.spellSigil.spellSigilStats.range)
	t.parallel().tween_property(self,"speed",0,currentWand.spellSigil.spellSigilStats.range)

var recivedDamageMonster = []
func _on_area_2d_area_entered(area):
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("deathAnimation")
		speed = 0
	
	var monster = area.get_parent()
	if !recivedDamageMonster.has(monster):
		monster.reciveDamage(currentWand.getDamage(),global_position)
		recivedDamageMonster.append(monster)
