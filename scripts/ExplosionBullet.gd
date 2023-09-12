extends Bullet

func _ready():
	super()
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property($Sprite2D,"rotation_degrees",rotation_degrees+100,currentWand.spellSigil.spellSigilStats.range)
	t.parallel().tween_property(self,"speed",0,currentWand.spellSigil.spellSigilStats.range)
