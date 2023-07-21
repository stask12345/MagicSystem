extends CharacterBody2D
class_name Monster
@export var stats : MonsterStats
@onready var maxHp = stats.hp
@onready var player = get_node("/root/MainScene/TileMap/Player")
@onready var hpBar = $HPBar
@onready var navigationAgent := $NavigationAgent2D
@export var agressionTime : float = 3
@export var advancedAnimation : bool = false

var lastDamage = 0
var agressive = false
var alive = true
@onready var timer : Timer = $Timer
@onready var system : GameSystem = get_node("/root/MainScene")

func _ready():
	timer.connect("timeout",loseTrigger)

func _physics_process(delta):
	if velocity != Vector2(0,0) and alive:
		move_and_slide()

func reciveDamage(damage, hitPosition):
	stats.hp -= damage
	hpBar.updateHealthBar(stats.hp, maxHp)
	showDamageLabel(damage)
	reciveDamageAnimation()
	knock(hitPosition,5)
	if stats.hp <= 0:
		system.deleteMonsterFromMap(self)
		dropCoins()
		$MonsterBody/CollisionShape2D.set_deferred("disabled",true) 
		alive = false
		colorTween.kill()
		$AnimationPlayer.play("death")

var colorTween
func reciveDamageAnimation():
	var t = get_tree().create_tween()
	colorTween = t
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property($Sprite2D,"self_modulate",Color(4,4,4),0.1)
	t.tween_property($Sprite2D,"self_modulate",Color(1,1,1),0.1)

var knockBackTween
func knock(point, power, time = 0.1):
	var direction =  point - global_position
	direction = -direction
	direction.normalized()
	
	var previousVelocity = velocity
	
	var knockbackDirection = (direction * power)
	velocity += knockbackDirection
	await get_tree().create_timer(time).timeout
	velocity -= knockbackDirection
	
	if self is MonsterSlime:
		if (velocity.x == 0 and velocity.y == 0) or (previousVelocity.x < 0 and velocity.x >= 0) or (previousVelocity.x > 0 and velocity.x <= 0) or (previousVelocity.y < 0 and velocity.y >= 0) or (previousVelocity.y > 0 and velocity.y <= 0):
			velocity = Vector2(0,0)
	

var damageLabel = preload("res://objects/utility/DamageLabel.tscn")
func showDamageLabel(damage):
	var l = damageLabel.instantiate()
	l = l
	l.get_child(0).text = str(damage)
	
	if lastDamage != 0:
		var damageDiffrence = damage/lastDamage
		if damageDiffrence > 1.5:
			damageDiffrence = 1.5
		if damageDiffrence < 0.75:
			damageDiffrence = 0.75
		l.scale = l.scale * damageDiffrence
	lastDamage = damage
	
	var x = 0
	x -= randi()%5
	x += randi()%7
	l.position = Vector2(x,-5 - randi()%10)
	
	add_child(l)

func _on_trigger_area_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area.get_parent().name == "Player":
		gainTrigger()
		timer.stop()

func _on_trigger_area_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player":
		if stats.hp > 0:
			timer.stop()
			timer.wait_time = agressionTime
			timer.start()

func gainTrigger():
	if !agressive: 
		showAgressionMark()
	agressive = true

func loseTrigger():
	agressive = false

var agressionMark = preload("res://objects/utility/ExplonationMark.tscn")
func showAgressionMark():
	var m = agressionMark.instantiate()
	m.position.y -= $Sprite2D.texture.get_height()
	add_child(m)

var coin = preload("res://objects/elements/GoldCoin.tscn")
func dropCoins():
	var numberOfCoins = randi_range(stats.coinsMin, stats.coinsMax)
	
	for i in numberOfCoins:
		var c : Node2D = coin.instantiate()
		c.rotation_degrees = randi()%180
		get_parent().add_child(c)
		c.global_position = global_position
		c.animateCoin()
