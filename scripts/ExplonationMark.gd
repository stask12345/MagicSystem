extends Sprite2D

func _ready():
	var t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self,"position:y",position.y - 15, 0.2)
	t.tween_callback(queue_free)
