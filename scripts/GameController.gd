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
	if monstersOnMap.has(enemy):
		monstersOnMap.erase(enemy)
		%CenterTop.updateWaveTimer()
	if monstersOnMap.size() == 0 and currentWave == maxWaves:
		endLevel()

func endLevel():
	var menuInstance = load("res://Menu.tscn")
	var menu = menuInstance.instantiate()
	resourcesData.updateMapProgress(currentMapId,tileMap.mapSize+1)
	get_node("/root/MainScene").add_child(menu)
	
	queue_free()
