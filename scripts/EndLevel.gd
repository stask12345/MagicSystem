extends CanvasLayer

@onready var resources = get_node("/root/MainScene/Resources")
var totalExp : float
var previousExp : float
var canExit = false

func _ready():
	previousExp = resources.playerData.exp
	resources.playerData.exp += system.expCollectedInRun
	
	var progress := (float) (previousExp/resources.getTotalExp())
	totalExp = resources.getTotalExp()
	expBar.scale.x = progress
	lightParticles.position.x = (progress * maxBarPosition)
	light.scale = Vector2(1 + (1 - progress),1 - progress + (1 - progress))
	
	expTotalCounter.text = str(previousExp) + "/" + str(resources.getTotalExp())
	if lightParticles.position.x == 0:
		lightParticles.visible = false
	
	button.connect("pressed",exitLevel)
	endLevel()

func endLevel():
	var camera = get_node("/root/MainScene/Game").camera
	camera.shake(20,4)
	$CenterTop/EndScreen.visible = true
	await get_tree().create_timer(0.5).timeout
	var maxGold : int = system.goldCollectedInRun
	var crystalsCollected : int = system.crystalsCollectedInRun
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT)
	t.tween_method(updateGoldCounter,0,maxGold,1.5)
	t.parallel().tween_method(updateCrystalsCouter,0,crystalsCollected,1.5)
	var previousExpInt : int = previousExp #for errors with precision in counter
	var e : int = resources.playerData.exp
	t.parallel().tween_method(updateExpCouter,previousExp,e,1.5)
	t.tween_callback(updateExpBar)

@onready var system : GameSystem = get_node("/root/MainScene/Game")
@onready var goldCounter = $CenterTop/EndScreen/GoldCollected
var maxGold = 0
var shownedGold = 0
func updateGoldCounter(gold):
	goldCounter.text = str(gold)

@onready var crystalsCounter = $CenterTop/EndScreen/CrystalsCollected
func updateCrystalsCouter(crystals):
	crystalsCounter.text = str(crystals)

@onready var expCounter = $CenterTop/EndScreen/expCollected
func updateExpCouter(exp):
	expCounter.text =  "+" + str(int(exp)) + " EXP"

@onready var expBar = $CenterTop/EndScreen/ProgressBar/bar
@onready var light = $CenterTop/EndScreen/ProgressBar/bar/Control/LightCircleSmall
@onready var lightParticles = $CenterTop/EndScreen/ProgressBar/light/LightCircleSmall2
var maxBarPosition = 140
func updateExpBar():
	var progress = (float) (float(resources.playerData.exp)/float(resources.getTotalExp()))
	if progress > 1:
		progress = 1
	light.scale = Vector2(1 + (1 - progress),1 - progress + (1 - progress))
	lightParticles.visible = true
	
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT)
	t.tween_property(lightParticles,"position:x",(progress * maxBarPosition),1)
	t.parallel().tween_property(expBar,"scale:x",(progress),1)
	t.parallel().tween_method(updateExpTotalCouter,previousExp,resources.playerData.exp,1)
	t.tween_callback(showEndLabel)

@onready var expTotalCounter = $CenterTop/EndScreen/ExpTotal
func updateExpTotalCouter(exp):
	expTotalCounter.text =  str(int(exp)) + "/" + str(int(totalExp))

@onready var button = $CenterTop/EndScreen/TouchScreenButton
func showEndLabel():
	$CenterTop/EndScreen/LabelEnd.visible = true
	$CenterTop/EndScreen/LabelEnd/AnimationPlayer.play("idle")
	canExit = true

func exitLevel():
	if canExit:
		system.endLevel()
