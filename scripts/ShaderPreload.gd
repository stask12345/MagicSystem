extends Node2D

func _ready(): #loads shaders on map to buffor them, then deletes this scene
	await get_tree().create_timer(0.1).timeout
	call_deferred("queue_free")
