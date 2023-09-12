extends TileMap
class_name TileSystem

var tileMaxHeight : int
var tileMaxWidth : int
var availableTiles : Array[Vector2i] = []
var usedTiles : Array[Vector2i] = []

enum mapSizeEnum {
	small,
	normal,
	big
}

var tiles : Dictionary = {
	"grass1": Vector2i(0,0),
	"grass2": Vector2i(1,0),
	"grass3": Vector2i(0,1),
	"grass4": Vector2i(1,1)
}

enum objects {
	spawn = 0,
	tree = 1,
	chest = 2
}

enum palettes {
	world = 0,
	objects = 6
} 

enum layers {
	ground = 0,
	objects = 1,
	background = 2,
	coast = 3
}

var waterPatterns = [ #First argument is ground, second water
	Vector2(0,17),Vector2(1,18),Vector2(2,19),Vector2(3,20),Vector2(4,21),Vector2(5,22),
	Vector2(33,34),
	Vector2(7,24),
	Vector2(8,25),
	Vector2(44,43)
]

var grassPatterns = [9,10,11,12,13,14,15,16,26,27,28,29,30,31,32]

var treePatterns = [35,36,37,38,39,40,41,42]

var decorations = [ # z is alternative tile, 1 set, 0 unset
	Vector3(9,0,1),
	Vector3(9,1,1),
	Vector3(10,0,0),
	Vector3(10,1,1),
	Vector3(11,0,0),
	Vector3(12,0,0),
	Vector3(12,1,1),
	Vector3(13,0,1),
	Vector3(11,1,0),
	Vector3(12,1,0),
	Vector3(13,1,0)
]

func generateWaterPattern():
	var waterPattern = waterPatterns.pick_random()
	var pos = Vector2i(-((tile_set.get_pattern(waterPattern[0]).get_size().x)/2) + randi()%(tileMaxWidth+(tile_set.get_pattern(waterPattern[0]).get_size().x)/2),-((tile_set.get_pattern(waterPattern[0]).get_size().y)/2) + randi()%tileMaxHeight + (tile_set.get_pattern(waterPattern[0]).get_size().y)/2)
#	var pos = Vector2i(-2,19)
	
	if checkIfOccupied(pos,tile_set.get_pattern(waterPattern[0]).get_size()):
		print("Unabled to set water pond!")
		return
	
	set_pattern(layers.coast,pos,tile_set.get_pattern(waterPattern[0]))
	set_pattern(layers.background,pos + Vector2i(1,1), tile_set.get_pattern(waterPattern[1]))
	
	var ut = tile_set.get_pattern(waterPattern[1]).get_used_cells()
	for i in ut.size():
		ut[i].x += pos.x + 1 #+1 because water is offset compered to coast tiles
		ut[i].y += pos.y + 1 
	
	var ut1 = tile_set.get_pattern(waterPattern[0]).get_used_cells()
	for i in ut1.size():
		ut1[i].x += pos.x + 1 #used coast tiles
		ut1[i].y += pos.y + 1 
	
	usedTiles.append_array(ut)
	usedTiles.append_array(ut1)
	print(ut)

func generateGrassPattern(pos : Vector2i):
	var grassPattern = grassPatterns.pick_random()
	if !checkIfEmpty(pos,tile_set.get_pattern(grassPattern).get_size()):
		print("not empty tile!")
		return
	print("success!")
	set_pattern(layers.background,pos,tile_set.get_pattern(grassPatterns.pick_random()))

func checkIfEmpty(pos, size = Vector2i(0,0)): #check if tile is not set
	var y = size.y
	while size.x >= 0:
		while size.y >= 0:
			if get_cell_atlas_coords(layers.ground,pos + size) != Vector2i(-1,-1) or get_cell_atlas_coords(layers.background,pos + size) != Vector2i(-1,-1): #or get_cell_atlas_coords(layers.objects,pos + size) != Vector2i(-1,-1):
				return false
			size.y -= 1
		size.x -= 1
		size.y = y
	return true

func checkIfOccupied(pos, size = Vector2i(0,0)): #returns true if occupied
	var y = size.y
	while size.x >= 0:
		while size.y >= 0:
			if usedTiles.has(Vector2i(pos.x + size.x, pos.y + size.y)):
				return true
			size.y -= 1
		size.x -= 1
		size.y = y
	return false

func setUpMap():
	for x in tileMaxWidth:
		for y in tileMaxHeight:
			availableTiles.append(Vector2i(x,y))

func generateDecoration(numberOfDecoration):
	calculateAvailableTiles()
	
	for i in numberOfDecoration:
		var d : Vector3 = decorations.pick_random()
		if d.z == 0:
			set_cell(1,availableTiles.pick_random(),0,Vector2(d.x,d.y))
		else:
			if randi()%2 == 0:
				set_cell(1,availableTiles.pick_random(),0,Vector2(d.x,d.y),1)

func generateTrees(numberOfTrees,numberOfPaterns):
	calculateAvailableTiles()
	
	for i in numberOfPaterns: 
		var p = treePatterns.pick_random()
		var pos = availableTiles.pick_random()
		if checkIfOccupied(pos,tile_set.get_pattern(p).get_size()):
			print("unabled to set tree pattern!")
			continue
		print("check")
		set_pattern(layers.objects,pos,tile_set.get_pattern(p))
		
		var ut = tile_set.get_pattern(p).get_used_cells()
		for u in ut.size():
			ut[u].x += pos.x + 1 #+1 because water is offset compered to coast tiles
			ut[u].y += pos.y + 1 
		usedTiles.append_array(ut)
		calculateAvailableTiles()
	
	for i in numberOfTrees:
		var pos = availableTiles.pick_random()
		set_cell(layers.objects,pos,palettes.objects,Vector2i(0,0),objects.tree)
		availableTiles.erase(pos)
		usedTiles.push_back(pos)

func calculateAvailableTiles():
	var a : Array[Vector2i]
	for t in availableTiles:
		if !usedTiles.has(t):
			a.append(t)
	availableTiles = a

func generateChests(numberOfChests):
	for i in numberOfChests:
		var tile = availableTiles.pick_random()
		
		set_cell(layers.objects,tile,palettes.objects,Vector2i(0,0),objects.chest)
		
		availableTiles.erase(tile)
		usedTiles.append(tile)

func generateSpawnPoint():
	var x = 3 + randi()%(tileMaxWidth-8)
	var y = 3 + randi()%(tileMaxHeight-8)
	var pos = Vector2i(x,y)
	
	set_cell(layers.objects,pos,palettes.objects,Vector2i(0,0),objects.spawn)
	availableTiles.erase(pos)
	availableTiles.erase(Vector2i(pos.x+1,pos.y))
	availableTiles.erase(Vector2i(pos.x,pos.y+1))
	availableTiles.erase(Vector2i(pos.x+1,pos.y+1))
	usedTiles.append(pos)
	usedTiles.append(Vector2i(pos.x+1,pos.y))
	usedTiles.append(Vector2i(pos.x,pos.y+1))
	usedTiles.append(Vector2i(pos.x+1,pos.y+1))
	
	%Player.global_position = Vector2(pos.x * 5 * 16 + 77,pos.y * 5 * 16 + 40)
	get_node("/root/MainScene/Game/CanvasLayer").process_mode = Node.PROCESS_MODE_DISABLED

func setUpNavigation():
	var allBackgroundTiles = get_used_cells(layers.background) #adding water tiles(with navigation) to backgroundTiles
	var waterLayerPolygons = []
	var backgroundTiles = []
	for bt in allBackgroundTiles:
		if get_cell_tile_data(layers.background,bt).get_custom_data("navigation") == true:
			backgroundTiles.append(bt)
	
	var navigationMargin = 6 #change to make bigger navigation "overflow"
	var pointPackages = []
	for t in backgroundTiles: #Getting points from tiles, making packages with points and directions
		if !backgroundTiles.has(Vector2i(t.x,t.y-1)) and !backgroundTiles.has(Vector2i(t.x-1,t.y)):
			var pos = getCellPosition(t)
			pointPackages.append([Vector2(pos.x-navigationMargin,pos.y-navigationMargin),"right"])
		if backgroundTiles.has(Vector2i(t.x,t.y-1)) and backgroundTiles.has(Vector2i(t.x-1,t.y)) and !backgroundTiles.has(Vector2i(t.x-1,t.y-1)):
			var pos = getCellPosition(t)
			pointPackages.append([Vector2(pos.x-navigationMargin,pos.y-navigationMargin),"top"])
		
		if !backgroundTiles.has(Vector2i(t.x,t.y-1)) and !backgroundTiles.has(Vector2i(t.x+1,t.y)):
			var pos = getCellPosition(t)
			pointPackages.append([Vector2(pos.x+16+navigationMargin,pos.y-navigationMargin),"down"])
		if backgroundTiles.has(Vector2i(t.x,t.y-1)) and backgroundTiles.has(Vector2i(t.x+1,t.y)) and !backgroundTiles.has(Vector2i(t.x+1,t.y-1)):
			var pos = getCellPosition(t)
			pointPackages.append([Vector2(pos.x+16+navigationMargin,pos.y-navigationMargin),"right"])
		
		if !backgroundTiles.has(Vector2i(t.x,t.y+1)) and !backgroundTiles.has(Vector2i(t.x-1,t.y)):
			var pos = getCellPosition(t)
			pointPackages.append([Vector2(pos.x-navigationMargin,pos.y+16+navigationMargin),"top"])
		if backgroundTiles.has(Vector2i(t.x,t.y+1)) and backgroundTiles.has(Vector2i(t.x-1,t.y)) and !backgroundTiles.has(Vector2i(t.x-1,t.y+1)):
			var pos = getCellPosition(t)
			pointPackages.append([Vector2(pos.x-navigationMargin,pos.y+16+navigationMargin),"left"])
		
		if !backgroundTiles.has(Vector2i(t.x,t.y+1)) and !backgroundTiles.has(Vector2i(t.x+1,t.y)):
			var pos = getCellPosition(t)
			pointPackages.append([Vector2(pos.x+16+navigationMargin,pos.y+16+navigationMargin),"left"])
		if backgroundTiles.has(Vector2i(t.x,t.y+1)) and backgroundTiles.has(Vector2i(t.x+1,t.y)) and !backgroundTiles.has(Vector2i(t.x+1,t.y+1)):
			var pos = getCellPosition(t)
			pointPackages.append([Vector2(pos.x+16+navigationMargin,pos.y+16+navigationMargin),"down"])
	
	var pointPackagesBackup = []
	pointPackagesBackup.append_array(pointPackages)
	
	var polygons = []
	
	print("connecting")
	
	while pointPackages.size() > 0: #connecting points
		var shape = []
		var startPoint = findUpperRightPoint(pointPackages)
		var originalStartPoint = startPoint
		
		while true:
			if startPoint != originalStartPoint:
				pointPackages.erase(startPoint)
			shape.append(startPoint[0])
			var nextPoint = null
			for p in pointPackages:
				nextPoint = findNewConnectedPoint(p,startPoint,nextPoint)
			startPoint = nextPoint
			if nextPoint == null or nextPoint[1] == "error":
				polygons.append(shape)
				break
			if nextPoint == originalStartPoint:
				pointPackages.erase(originalStartPoint)
				polygons.append(shape)
				break
	
	waterLayerPolygons.append_array(polygons)
	
	print("map boundary early")
	
	var mapWidth = getCellPosition(Vector2i(tileMaxWidth,0)).x
	var mapHeight = getCellPosition(Vector2i(0,tileMaxHeight)).y
	var boundaryPlygons = [] #polygons on map boundary
	var polygonsToDestroy = []
	for p in polygons:
		if p.any(func(t): return t.x < 0) or p.any(func(t): return t.x > mapWidth) or p.any(func(t): return t.y < 0) or p.any(func(t): return t.y > mapHeight):
			var direction = ""
			var newPolygon = []
			newPolygon.append_array(p)
			var leftTop = 9999
			var leftBottom = 0
			var rightTop = 9999
			var rightBottom = 0
			var topLeft = 9999
			var topRight = 0
			var bottomLeft = 9999
			var bottomRight = 0
			var index = 0
			var previousPoint = null
			var intersectionPoints = []
			for point in p: #calculating boundary points of polygon
				var nextPoint
				if (index+1) != p.size():
					nextPoint = p[index+1]
				else:
					nextPoint = p[0]
				index += 1
				if point.x < 0:
					if point.y < leftTop:
						if nextPoint.x > 0:
							leftTop = point.y
					if point.y > leftBottom:
						if previousPoint != null and previousPoint.x > 0:
							leftBottom = point.y
					if point.y > 0 and point.y < mapHeight and previousPoint != null and (previousPoint.x * point.x < 0 or nextPoint.x * point.x < 0):
						intersectionPoints.append(Vector2(0,point.y)) #test
					newPolygon.erase(point)
				if point.x > mapWidth:
					if point.y < rightTop:
						if previousPoint != null and previousPoint.x < mapWidth:
							rightTop = point.y
					if point.y > rightBottom:
						if nextPoint.x < mapWidth:
							rightBottom = point.y
					if point.y > 0 and point.y < mapHeight and previousPoint != null and (previousPoint.x < mapWidth or nextPoint.x < mapWidth):
						intersectionPoints.append(Vector2(mapWidth,point.y)) #test
					newPolygon.erase(point)
				if point.y < 0:
					if point.x < topLeft:
						if previousPoint == null: #?????!!!! previousPoint != null and previousPoint.y > 0 I don't know if this will broke smt but order starts from upper right corner so, I temporarly put it like this
							topLeft = point.x
					if point.x > topRight:
						if nextPoint.y > 0:
							topRight = point.x
					if point.x > 0 and point.x < mapWidth and previousPoint != null and (previousPoint.y * point.y < 0 or nextPoint.y * point.y < 0):
						intersectionPoints.append(Vector2(point.x,0)) #test
					newPolygon.erase(point)
				if point.y > mapHeight:
					if point.x < bottomLeft:
						if nextPoint.y < mapHeight:
							bottomLeft = point.x
					if point.x > bottomRight:
						if previousPoint != null and previousPoint.y < mapHeight:
							bottomRight = point.x
					if point.y > 0 and point.y < mapHeight and previousPoint != null and (previousPoint.y < mapHeight or nextPoint.y < mapHeight):
						intersectionPoints.append(Vector2(point.x,mapHeight)) #test
					newPolygon.erase(point)
				previousPoint = point
			
			print(intersectionPoints)
			
			if leftTop != 9999 and leftTop > 0 and leftTop <= mapHeight: #Adding new border points
				var newPoint = Vector2(0,leftTop)
				if !newPolygon.has(newPoint):
					newPolygon.push_front(newPoint)
				direction += "l"
			if leftBottom != 0 and leftBottom < mapHeight and leftBottom > 0:
				var newPoint = Vector2(0,leftBottom)
				if !newPolygon.has(newPoint):
					newPolygon.push_back(newPoint)
			if rightTop != 9999 and rightTop > 0 and rightTop <= mapHeight:
				var newPoint = Vector2(mapWidth,rightTop)
				if !newPolygon.has(newPoint):
					newPolygon.push_back(newPoint)
			if rightBottom != 0 and rightBottom < mapHeight and rightBottom > 0:
				var newPoint = Vector2(mapWidth,rightBottom)
				if !newPolygon.has(newPoint):
					newPolygon.push_front(newPoint)
				direction += "r"
			if topLeft != 9999 and topLeft > 0 and topLeft < mapWidth:
				var newPoint = Vector2(topLeft,0)
				if !newPolygon.has(newPoint):
					newPolygon.push_back(newPoint)
			if topRight != 0 and topRight < mapWidth and topRight < 0:
				var newPoint = Vector2(topRight,0)
				if !newPolygon.has(newPoint):
					newPolygon.push_front(newPoint)
				direction += "t"
			if bottomLeft != 9999 and bottomLeft > 0 and bottomLeft < mapWidth:
				var newPoint = Vector2(bottomLeft,mapHeight)
				if !newPolygon.has(newPoint):
					newPolygon.push_front(newPoint)
				direction += "b"
			if bottomRight != 0 and bottomRight < mapWidth and bottomRight > 0:
				var newPoint = Vector2(bottomRight,mapHeight)
				if !newPolygon.has(newPoint):
					newPolygon.push_back(newPoint)
			
			var lastPoint = newPolygon[newPolygon.size()-1]
			newPolygon.erase(lastPoint)
			for ip in intersectionPoints:
				if !newPolygon.has(ip):
					newPolygon.append(ip)
			newPolygon.append(lastPoint)
			
			if newPolygon != p:
				polygonsToDestroy.append(p)
				boundaryPlygons.append([newPolygon,direction])
		
	for p in polygonsToDestroy:
		polygons.erase(p)
	
	
	var mainOutline = []
	
	
	var generateCornerPoint = true
	var currentPolygon : String = ""
	var currentDirection : String = ""
	
	print("map boundary")
	
	while currentPolygon != "t": #connecting polygons to map boundary
		if currentPolygon == "":
			currentPolygon = "l"
			currentDirection = "right"
		else:
			if currentPolygon == "l":
				currentPolygon = "b"
				currentDirection = "top"
			else:
				if currentPolygon == "b":
					currentPolygon = "r"
					currentDirection = "left"
				else:
					if currentPolygon == "r":
						currentPolygon = "t"
						currentDirection = "down"
	
		print("border 1")
	
		var sidePolygons = []
	
		while boundaryPlygons.any(func(p): return p[1] == currentPolygon):
			var p
			for b in boundaryPlygons:
				if b[1] == currentPolygon:
					p = b[0]
			
			var newPolygon = []
			var startPoint = [p[0],currentDirection]
			var previousPoint = null
#			var previousPositionPoint = null #for calculating which polygon should be draw first on specific side
			
			var testError = 0
			while true:
				testError += 1
				if testError > 250:
					print("error")
					return
				
				print("border 2")
				
				
				if startPoint[0] != p[0]:
					var d
					for t in pointPackagesBackup:
						if t[0] == startPoint[0]:
							d = t[1]
							break
					startPoint = [startPoint[0], d]
				newPolygon.append(startPoint[0])
				var nextPoint = null
				var error = ""
				while error != "onward":
					
					print("border 3")
					
					for point in p:
						if point != startPoint[0] and !newPolygon.has(point):
							point = [point,""]
							nextPoint = findNewConnectedPoint(point,startPoint,nextPoint)
					if nextPoint == null or nextPoint[1] == "error":
						if error == "": 
							error = "top"
							startPoint[1] = "top"
							if previousPoint == null or previousPoint[1] != "top":
								continue
						if error == "top":
							error = "right"
							startPoint[1] = "right"
							if previousPoint == null or previousPoint[1] != "right":
								continue
						if error == "right":
							error = "down"
							startPoint[1] = "down"
							if previousPoint == null or previousPoint[1] != "down":
								continue
						if error == "down":
							error = "left"
							startPoint[1] = "left"
							if previousPoint == null or previousPoint[1] != "left":
								continue
						if error == "left":
							error = "onward"
					else:
						error = "onward"
				previousPoint = startPoint
				startPoint = nextPoint
				if startPoint[0] == p[p.size()-1]:
					newPolygon.append(startPoint[0])
					break
			
			boundaryPlygons.erase([p,currentPolygon])
			if sidePolygons.size() == 0:
				sidePolygons.append(newPolygon)
			else:
				if currentPolygon == "l":
					if sidePolygons[0][sidePolygons.size()-1].y < newPolygon[0].y:
						sidePolygons.append(newPolygon)
					else:
						sidePolygons.push_front(newPolygon)
				if currentPolygon == "b":
					if sidePolygons[0][sidePolygons.size()-1].x < newPolygon[0].x:
						sidePolygons.append(newPolygon)
					else:
						sidePolygons.push_front(newPolygon)
				if currentPolygon == "r":
					if sidePolygons[0][sidePolygons.size()-1].y > newPolygon[0].y:
						sidePolygons.append(newPolygon)
					else:
						sidePolygons.push_front(newPolygon)
				if currentPolygon == "t":
					if sidePolygons[0][sidePolygons.size()-1].x > newPolygon[0].x:
						sidePolygons.append(newPolygon)
					else:
						sidePolygons.push_front(newPolygon)
			
			var lastPoint = newPolygon[newPolygon.size()-1]
			if currentPolygon == "l" and lastPoint.x != 0:
				generateCornerPoint = false
			if currentPolygon == "b" and lastPoint.y != mapHeight:
				generateCornerPoint = false
			if currentPolygon == "r" and lastPoint.x != mapWidth:
				generateCornerPoint = false
			if currentPolygon == "t" and lastPoint.y != 0:
				generateCornerPoint = false
		
		for sp in sidePolygons:
				mainOutline.append_array(sp)
		
		if generateCornerPoint:
			if currentPolygon == "l":
				mainOutline.append(Vector2(0,mapHeight))
			if currentPolygon == "b":
				mainOutline.append(Vector2(mapWidth,mapHeight))
			if currentPolygon == "r":
				mainOutline.append(Vector2(mapWidth,0))
			if currentPolygon == "t":
				mainOutline.append(Vector2(0,0))
		generateCornerPoint = true
	
	
	polygons.push_front(mainOutline)
	
	
	print("navigacja")
	var polygon = NavigationPolygon.new() #Drawing navigation
	for p in polygons:
		print("polygon ", p)
		var o1 = PackedVector2Array(p)
		polygon.add_outline(o1)
	polygon.make_polygons_from_outlines()
	$NavigationRegion2D.navigation_polygon = polygon
	
	var waterPolygon = NavigationPolygon.new()
	for p in waterLayerPolygons:
		var o = PackedVector2Array(p)
		waterPolygon.add_outline(o)
	waterPolygon.make_polygons_from_outlines()
	$NavigationRegion2DWater.navigation_polygon = waterPolygon

func getCellPosition(cell):
	return Vector2(cell.x * 16, cell.y * 16)

func getRightUpperCorner(borderPoints): #sub function for navigation
	var targetVector
	var upOrDown = borderPoints[0]
	borderPoints.erase(upOrDown)
	if upOrDown == 0: #cases of diffrent tile path placement
		targetVector = Vector2(9999,9999)
		print("2!")
		for t in borderPoints: #0 - normal, 1 - reversed, 2 - special...
			if t.y <= targetVector.y:
				if t.y == targetVector.y:
					if t.x <= targetVector.x:
						targetVector = t
				else:
					targetVector = t
	if upOrDown == 1:
		targetVector = Vector2(-9999,-9999)
		print("0!")
		for t in borderPoints:
			if t.y >= targetVector.y:
				if t.y == targetVector.y:
					if t.x >= targetVector.x:
						targetVector = t
				else:
					targetVector = t
	if upOrDown == 2:
		targetVector = Vector2(9999,-9999)
		print("2!")
		for t in borderPoints:
			if t.y >= targetVector.y:
				if t.y == targetVector.y:
					if t.x <= targetVector.x:
						targetVector = t
				else:
					targetVector = t
	if upOrDown == 3:
		targetVector = Vector2(-9999,9999)
		print("3!")
		for t in borderPoints:
			if t.y <= targetVector.y:
				if t.y == targetVector.y:
					if t.x >= targetVector.x:
						targetVector = t
				else:
					targetVector = t
	if upOrDown == 4:
		targetVector = Vector2(-9999,-9999)
		print("4!")
		for t in borderPoints:
			if t.y >= targetVector.y:
				if t.y == targetVector.y:
					if t.x >= targetVector.x:
						targetVector = t
				else:
					targetVector = t
	
	return targetVector

func findUpperRightPoint(arr):
	var point = [Vector2(9999,9999),""]
	for array in arr:
		if array[0].x <= point[0].x:
			if array[0].x == point[0].x:
				if array[0].y < point[0].y:
					point = array
			else:
				point = array
	return point

func findNewConnectedPoint(p,startPoint,nextPoint):#Part of navigation
	if startPoint[1] == "right":
		if p[0].x > startPoint[0].x:
			if nextPoint == null:
				nextPoint = [Vector2(9999,0),"error"]
			if p[0].y == startPoint[0].y and p[0].x < nextPoint[0].x:
				nextPoint = p
	if startPoint[1] == "left":
		if p[0].x < startPoint[0].x:
			if nextPoint == null:
				nextPoint = [Vector2(-9999,0),"error"]
			if p[0].y == startPoint[0].y and p[0].x > nextPoint[0].x:
				nextPoint = p
	if startPoint[1] == "top":
		if p[0].y < startPoint[0].y:
			if nextPoint == null:
				nextPoint = [Vector2(0,-9999),"error"]
			if p[0].x == startPoint[0].x and p[0].y > nextPoint[0].y:
				nextPoint = p
	if startPoint[1] == "down":
		if p[0].y > startPoint[0].y:
			if nextPoint == null:
				nextPoint = [Vector2(0,9999),"error"]
			if p[0].x == startPoint[0].x and p[0].y < nextPoint[0].y:
				nextPoint = p
	return nextPoint
