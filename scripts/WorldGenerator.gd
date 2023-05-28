extends TileMap

var maxLenght = 20
var maxWidth = 20

func _ready():
	#generateGrassland() 
	pass

func generateGrassland():
	for w in maxWidth:
		for l in maxLenght:
			set_cell(0,Vector2i(w,l),0,Vector2i(0,0))
			if getChance(10):
				set_cell(0,Vector2i(w,l),0,Vector2i(randi()%4,randi()%2))

func getChance(propability):
	if randi()%propability == 0:
		return true
	else:
		return false
