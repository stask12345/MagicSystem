extends Sprite2D

@onready var player = get_node("/root/MainScene/Game/TileMap/Player")
@export var value : int = 1

var follow = false
var speed = 10

@onready var goldLabel = get_node("/root/MainScene/Game/CanvasLayer/RightTop/Gold")
func _physics_process(delta):
	if follow:
		speed += 2
		position = position.move_toward(player.position,delta * speed)
		if position.distance_to(player.position) < 8:
			goldLabel.updateGoldCounter(value)
			queue_free()

func animateCoin():
	var direction = Vector2(-1 + randf()*2, -1 + randf()*2)
	var power : float = randi()%100
	var time : float = (float)(power/150)
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUART)
	t.tween_property(self,"global_position",global_position + (direction * power), time)
	
	#t.set_ease(Tween.EASE_IN)
	#t.tween_property(self,"global_position",player.global_position,0.5)
	t.tween_callback(startFollowingPlayer)


func startFollowingPlayer():
	follow = true
