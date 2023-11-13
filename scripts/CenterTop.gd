extends Control #script for wave timer

@onready var system : GameSystem = get_node("/root/MainScene/Game")

#func _ready():
#	call_deferred("updateWaveTimer")

func updateWaveTimer():
	if !system.wavesEnded:
		$WaveCount.text = "Wave " + str(system.currentWave + 1) + "/" + str(system.maxWaves)
		$WaveIndicator.text = str(roundi(system.waveTimer.time_left))
		await $Timer.timeout
		updateWaveTimer()
	else:
		if $WaveCount.text != "Defeat all enemies!":
			$Timer.stop()
			await get_tree().create_timer(1).timeout
		$WaveCount.text = "Defeat all enemies!"
		$WaveIndicator.text = "Enemies left: " + str(system.monstersOnMap.size())
