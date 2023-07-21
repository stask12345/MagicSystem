extends Label

var animationTime = 0.3
@onready var parent = get_parent()

func _ready():
	startAnimation()
	pass

func startAnimation():
	parent.scale.y = 0.4
	label_settings.font_color = Color(1,1,1)
	
	var t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN)
	t.tween_property(self,"position", Vector2(position.x,position.y-5), animationTime)
	t.parallel().tween_property(parent,"scale:y", 1, animationTime)
	t.parallel().tween_property(label_settings,"font_color", Color(0.5,0,0), animationTime)
	t.tween_property(self,"self_modulate:a", 0.4, 0.1)
	t.parallel().chain().tween_property(self,"position", Vector2(position.x,position.y+3), 0.1)
	t.tween_callback(destroy)

func destroy():
	get_parent().call_deferred("queue_free")
