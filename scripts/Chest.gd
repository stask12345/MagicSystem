extends Sprite2D

@export var coinsMin = 5
@export var coinsMax = 10

func _ready():
	frame = randi_range(0,1)

func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player":
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
		frame += 2
		dropCoins()
		var t = create_tween()
		t.tween_property(self,"self_modulate:a", 0, 1)
		t.tween_callback(queue_free)


var coin = preload("res://objects/elements/GoldCoin.tscn")
func dropCoins():
	var numberOfCoins = randi_range(coinsMin, coinsMax)
	
	for i in numberOfCoins:
		var c : Node2D = coin.instantiate()
		c.rotation_degrees = randi()%180
		get_parent().add_child(c)
		c.global_position = global_position
		c.animateCoin()
