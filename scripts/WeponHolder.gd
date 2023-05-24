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
	b.global_position = global_position

func waitForShoot():
	await get_tree().create_timer(0.6).timeout
	canShoot = true
