extends Sprite2D

func _ready():
	var t = get_tree().create_tween()
	t.tween_property(self,"scale",Vector2(0.7,0.7),0.5)
	t.tween_callback(queue_free)
	
	var t1 = get_tree().create_tween()
	t1.tween_property(self,"self_modulate",Color(1,1,1,0.1),0.4)
	pass

