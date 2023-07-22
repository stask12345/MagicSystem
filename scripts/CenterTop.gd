extends Control #script for wave timer

@onready var system : GameSystem = get_node("/root/MainScene")

func _ready():
	call_deferred("updateWaveTimer")

func updateWaveTimer():
	$WaveCount.text = "Wave " + str(system.currentWave + 1) + "/" + str(system.maxWaves)
	
	if !system.wavesEnded:
		$WaveIndicator.text = str(roundi(system.waveTimer.time_left))
		await $Timer.timeout
		updateWaveTimer()
	else:
		$Timer.stop()
		$WaveCount.text = "Defeat all enemies!"
		$WaveIndicator.text = "Enemies left: " + str(system.monstersOnMap.size())
