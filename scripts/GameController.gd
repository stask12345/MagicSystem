extends Node2D
class_name GameSystem

@onready var tileMap = %TileMap
@export var timeToNewWave = []
var monsterLists = []
@export var currentWave = 0
@export var maxWaves = 1
var wavesEnded = false
@onready var waveTimer : Timer = $WaveTimer
@onready var resourcesData : ResourceData = get_node("/root/MainScene/Resources")
var monstersOnMap : Array
var currentMapId : int
@onready var player = %Player
@onready var camera = %Camera
var goldCollectedInRun = 0
var expCollectedInRun = 0
var crystalsCollectedInRun = 0

func startWaveTimer():
	await get_tree().create_timer(5).timeout
	%TileMap.monsterList = monsterLists[currentWave+1]
	%TileMap.generateMonsterWave()
	waveTimer.connect("timeout",startNewWave)
	
	waveTimer.wait_time = timeToNewWave[currentWave] #timer for waves
	waveTimer.start()
	%CenterTop.updateWaveTimer()

func startNewWave():#starts waves
	%TileMap.monsterList = monsterLists[currentWave+1]
	if currentWave == maxWaves:
		%TileMap.monsterList.append_array(monsterLists[currentWave+1])
	%TileMap.generateMonsterWave()
	currentWave += 1
	if currentWave < maxWaves:
		waveTimer.wait_time = timeToNewWave[currentWave]
		waveTimer.start()
	else:
		wavesEnded = true #when waves ended 

func deleteMonsterFromMap(enemy): #used for tracking all enemies on map
	expCollectedInRun += enemy.stats.experienceRank * 5
	if monstersOnMap.has(enemy):
		monstersOnMap.erase(enemy)
		%CenterTop.updateWaveTimer()
	if monstersOnMap.size() == 0 and currentWave >= maxWaves:
		var t = get_tree().create_tween()
		t.set_ease(Tween.EASE_OUT)
		t.set_trans(Tween.TRANS_QUINT)
		t.tween_property(%Camera,"zoom",Vector2(%Camera.zoom.x+0.5,%Camera.zoom.y+0.5),0.5)
		t.tween_callback(normalSpeed)
		$CanvasLayer.visible = false

func normalSpeed():
	%Camera.shake(20,4)
	await get_tree().create_timer(0.2).timeout
	showEndLevelScreen()

func showEndLevelScreen():
	var endScreen = load("res://objects/utility/EndScreenCanvas.tscn")
	var es = endScreen.instantiate()
	add_child(es)

func endLevel():
	var menuInstance = load("res://Menu.tscn")
	var menu = menuInstance.instantiate()
	resourcesData.updateMapProgress(currentMapId,tileMap.mapSize+1)
	get_node("/root/MainScene").add_child(menu)
	
	queue_free()

