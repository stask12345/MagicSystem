extends CanvasLayer

func _ready():
	$Return/Button.connect("pressed",hideEquipment)
	$WandButton/Button.connect("pressed",openWandMenu)

func hideEquipment():
	var label = $Return
	var t = create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(label,"scale",Vector2(1.1,1.1),0.05)
	t.tween_property(label,"scale",Vector2(1,1),0.05)
	$"../CanvasLayer".equipmentOpen = false
	
	t.parallel().tween_property($"../CanvasLayer/Background","self_modulate",Color(0,0,0,0),0.1)
	t.tween_callback(func(): $"../Equipment".visible = false)

func openWandMenu():
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_CUBIC)
	
	t.tween_property($WandButton,"scale",Vector2($WandButton.scale.x+0.1,$WandButton.scale.y+0.1),0.05)
	t.tween_property($WandButton,"scale",Vector2($WandButton.scale.x,$WandButton.scale.y),0.05)
	t.tween_callback(func(): visible=false)
	t.tween_callback(func(): $"../Wand".visible = true)
