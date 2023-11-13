extends CanvasLayer

@onready var currentArea = $Container/Forest
var currentAreaIndex = 0
var errorMargin = 100
var errorTime = 0.3
var equipmentOpen = false

func _ready():
	currentArea.get_child(0).updateMapProgress()
	$DragTimer.wait_time = errorTime
	$Equipment/Label/Button.connect("pressed",openEquipment)
	$Center/ArrowUiRight/TouchScreenButton.connect("pressed",func(): swipeArea(1))
	$Center/ArrowUiLeft/TouchScreenButton.connect("pressed",func(): swipeArea(-1))
	
	if currentAreaIndex == 0:
		$Center/ArrowUiLeft.visible = false
	else:
		$Center/ArrowUiLeft.visible = true
	if currentAreaIndex == $Container.get_child_count()-1:
		$Center/ArrowUiRight.visible = false
	else:
		$Center/ArrowUiRight.visible = true

var touchPosition : Vector2
func _input(event):
	if event is InputEventScreenTouch and !equipmentOpen:
		var eve : InputEventScreenTouch = event
		if eve.is_released():
			var diff = eve.position.x - touchPosition.x
			changeArea(diff)
		
		if eve.is_pressed() and !eve.is_echo():
			touchPosition = eve.position
			$DragTimer.wait_time = errorTime
			$DragTimer.start()

var tween : Tween
func changeArea(dragValue):
	if abs(dragValue) > errorMargin and !$DragTimer.is_stopped():
		
		var direction : int
		if dragValue < 0:
			direction = 1
		else:
			direction = -1
		
		if (currentAreaIndex != $Container.get_child_count()-1 and direction == 1) or (currentAreaIndex != 0 and direction == -1):
			swipeArea(direction)

func endAnimation():
	if currentArea.get_child(0).mapId != -1:
		var t = get_tree().create_tween()
		t.set_ease(Tween.EASE_IN)
		t.set_trans(Tween.TRANS_QUAD)
		t.tween_property($Center,"modulate",Color(1,1,1,1),0.1)
		currentArea.get_child(0).updateMapProgress()
		
		if currentAreaIndex == 0:
			$Center/ArrowUiLeft.visible = false
		else:
			$Center/ArrowUiLeft.visible = true
		if currentAreaIndex == $Container.get_child_count()-1:
			$Center/ArrowUiRight.visible = false
		else:
			$Center/ArrowUiRight.visible = true

func openEquipment():
	var label = $Equipment/Label
	var t = create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(label,"scale",Vector2(1.1,1.1),0.05)
	t.tween_property(label,"scale",Vector2(1,1),0.05)
	equipmentOpen = true
	
	$Background.visible = true
	t.parallel().tween_property($Background,"self_modulate",Color.WHITE,0.3)
	t.tween_callback(func(): $"../Equipment".visible = true)

func swipeArea(direction):
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	
	$Center.modulate = Color(1,1,1,0)
	
	tween.tween_property($Container,"position:x",$Container.position.x-(700*direction),0.2)
	tween.parallel().tween_property(currentArea,"modulate",Color(0.2,0.2,0.2),0.2)
	tween.parallel().tween_property(currentArea,"rotation_degrees",(5*direction),0.2)
	tween.parallel().tween_property(currentArea,"position:y",-25,0.2)
	tween.parallel().tween_property($Container.get_child(currentAreaIndex+direction),"modulate",Color.WHITE,0.2)
	tween.parallel().tween_property($Container.get_child(currentAreaIndex+direction),"rotation_degrees",0,0.2)
	tween.parallel().tween_property($Container.get_child(currentAreaIndex+direction),"position:y",0,0.2)
	currentAreaIndex += direction
	currentArea = $Container.get_child(currentAreaIndex)
	tween.tween_callback(endAnimation)
