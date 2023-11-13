extends Control

@export var spriteCoin : Texture2D

var logInstance = preload("res://objects/utility/Log.tscn")
func addLog(value):
	var log = logInstance.instantiate()
	log.position = Vector2(0,0)
	
	for l in get_children():
		var t = get_tree().create_tween()
		t.set_trans(Tween.TRANS_QUART)
		t.tween_property(l,"position",Vector2(l.position.x + 15,l.position.y + 35), 0.1)
		l.modulate.a -= 0.25
#		l.rotation_degrees -= 3
	
	add_child(log)
	deleteChild()

func deleteChild():
	if get_child_count() > 5:
		get_child(0).call_deferred("queue_free")
