extends Sprite2D

var damage = 15

func _ready():
	$Area2D.connect("body_entered",closeTrap)

func closeTrap(area):
	z_index += 1
	frame = 1
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	var player = area.get_node("Character")
	player.getDamage(15,global_position,0.1,0.5)
