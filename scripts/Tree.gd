extends Sprite2D

func _ready():
	if randi()%2 == 0:
		scale.x = -1

func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	$AnimationPlayer.play("idle")
