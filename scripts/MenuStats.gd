extends Control

@onready var resources : ResourceData = get_node("/root/MainScene/Resources")

func _ready():
	updateStats()

func updateStats():
	$Rank.text = "Rank " + str(resources.playerData.rank)
	$Exp.text = str(resources.playerData.exp) + "/" + str(resources.getTotalExp())
	$Gold.text = "x " + str(resources.playerData.gold)
	$Crystals.text = "x " + str(resources.playerData.crystals)
	
	if $Rank/RankImage.hframes >= resources.playerData.rank:
		$Rank/RankImage.frame = resources.playerData.rank - 1
	else:
		$Rank/RankImage.frame = $Rank/RankImage.hframes - 1
	
	var levelProgress : float = resources.playerData.exp / resources.getTotalExp()
	$Exp/ProgressBarMini/progress.scale = Vector2(levelProgress,1)
