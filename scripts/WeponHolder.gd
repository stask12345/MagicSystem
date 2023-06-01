extends Node2D

@onready var joystickAttack = %JoystickAttack
@onready var mainScene = get_node("/root/MainScene")
var canShoot = true
var wepon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = joystickAttack.get_value_rotation()
	if joystickAttack.get_value() && canShoot:
		if get_child_count() > 0:
			wepon = get_child(0)
			canShoot = false
			shoot()
			waitForShoot()

func shoot():
	var b = preload("res://objects/MagicBullet.tscn").instantiate()
	b.rotation_degrees = rotation_degrees
	mainScene.add_child(b)
	b.global_position = wepon.global_position
	
	var t = get_tree().create_tween()
	t.tween_property(wepon,"offset",Vector2(wepon.offset.x - 5,wepon.offset.y),0.05)
	t.tween_property(wepon,"offset",Vector2(wepon.offset.x,wepon.offset.y),0.05)
	var t1 = get_tree().create_tween()
	t1.tween_property(self,"scale",Vector2(0.8,0.8),0.05)
	t1.tween_property(self,"scale",Vector2(1,1),0.05)
	var t2 = get_tree().create_tween()
	t2.tween_property(self,"rotation_degrees",rotation_degrees + 5,0.05)
	t2.tween_property(self,"rotation_degrees",rotation_degrees,0.05)
	
	var camera = get_node("%Camera")
	camera.shake(3,15)
	$Wand1/CPUParticles2D.emitting = true

func waitForShoot():
	await get_tree().create_timer(0.6).timeout
	canShoot = true
