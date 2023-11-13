extends Label

@onready var system = get_node("/root/MainScene/Game")
func updateGoldCounter(value):
	system.resourcesData.updatePlayerCoins(value)
	system.goldCollectedInRun += value
	text = str(system.resourcesData.getPlayerCoins())
	$"../LogContainer".addLog(value)
