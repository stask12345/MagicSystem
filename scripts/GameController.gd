extends Node2D
class_name GameSystem

@export var timeToNewWave = [30]
@export var currentWave = 0
@export var maxWaves = 1
var wavesEnded = false
@onready var waveTimer : Timer = $WaveTimer
var monstersOnMap : Array

func _ready():
	waveTimer.connect("timeout",startNewWave)
	
	waveTimer.wait_time = timeToNewWave[currentWave] #timer for waves
	waveTimer.start()

func startNewWave():#starts waves
	%TileMap.generateMonsterWave()
	currentWave += 1
	if currentWave < maxWaves:
		waveTimer.wait_time = timeToNewWave[currentWave]
		waveTimer.start()
	else:
		wavesEnded = true #when waves ended 

func deleteMonsterFromMap(enemy): #used for tracking all enemies on map
	if monstersOnMap.has(enemy):
		print("b")
		monstersOnMap.erase(enemy)
		%CenterTop.updateWaveTimer()
