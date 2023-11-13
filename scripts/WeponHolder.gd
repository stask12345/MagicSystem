extends Node2D

@onready var joystickAttack = %JoystickAttack
@onready var mainScene = get_node("/root/MainScene/Game")
var canShoot = true
var holdedWepon
@export var currentWand : Wand

func _ready():
	changeWand()

func changeWand():
	$Wand.texture = currentWand.textureWand

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation_degrees = joystickAttack.get_value_rotation()
	if joystickAttack.get_value() && canShoot:
		if get_child_count() > 0:
			holdedWepon = get_child(0)
			canShoot = false
			shoot()
			waitForShoot()

func shoot():
	var b : Bullet = currentWand.spellSigil.spellSigilStats.bulletType.instantiate()
	b.currentWand = currentWand
	b.rotation_degrees = rotation_degrees
	mainScene.add_child(b)
	b.global_position = holdedWepon.global_position
	
	var t = get_tree().create_tween()
	t.tween_property(holdedWepon,"offset",Vector2(holdedWepon.offset.x - 5,holdedWepon.offset.y),0.05)
	t.tween_property(holdedWepon,"offset",Vector2(holdedWepon.offset.x,holdedWepon.offset.y),0.05)
	var t1 = get_tree().create_tween()
	t1.tween_property(self,"scale",Vector2(0.8,0.8),0.05)
	t1.tween_property(self,"scale",Vector2(1,1),0.05)
	var t2 = get_tree().create_tween()
	t2.tween_property(self,"rotation_degrees",rotation_degrees + 5,0.05)
	t2.tween_property(self,"rotation_degrees",rotation_degrees,0.05)
	
#	var camera = get_node("%Camera")
#	camera.shake(3,15)
	$Wand/CPUParticles2D.emitting = true

func waitForShoot():
	await get_tree().create_timer(currentWand.spellSigil.spellSigilStats.reloadTime).timeout
	canShoot = true
