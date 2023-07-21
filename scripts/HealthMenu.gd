extends Control

@onready var character : Character = %Character
var fullHeart = preload("res://objects/utility/HPHearth.tscn")
var halfHeart = preload("res://objects/utility/HPHearthHalf.tscn")
var previousHpState : int
var animationArray = []

func _ready():
	call_deferred("setUpHearts")

func setUpHearts():
	var container = $GridContainer
	if container.get_child_count() > 0:
		var chs = container.get_children()
		chs.all(queue_free)
	
	var characterTotalHp = character.stats.totalHp
	previousHpState = characterTotalHp
	var fullHearts : int = characterTotalHp/30
	for i in fullHearts:
		var h = fullHeart.instantiate()
		container.add_child(h)
	
	if characterTotalHp%30 == 15:
		var h = halfHeart.instantiate()
		container.add_child(h)

func updateHearts():
	var hp = character.hp
	
	animationArray.clear()
	for h in $GridContainer.get_children():
		hp = fillHeart(h, hp)
	
	animateFilling()

func fillHeart(heart, fillValue : float):
	if fillValue >= 30:
		fillValue -= 30
		var currentFill = heart.get_node("Sprite/FillBackground/Fill").scale.y
		if currentFill != 1:
			animationArray.push_back(heart)
			animationArray.push_back((float)(1))
	else:
		var currentFill = heart.get_node("Sprite/FillBackground/EmptyFill").scale.y
		var nextFill : float = (float)(fillValue/30)
		currentFill = snapped(currentFill,0.1)
		if nextFill != currentFill:
			animationArray.push_back(heart)
			animationArray.push_back(nextFill)
		fillValue = 0
	return fillValue

func animateFilling(): #TODO animation speed depending on how much is filled
	var t : Tween = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	var animationCount = animationArray.size()/2
	var animationIndex = 0
	
	if animationCount > 0:
		if character.hp < previousHpState:
			for i in animationCount:
				var arrayLength = animationArray.size() - 1
				animationArray[arrayLength - animationIndex - 1].get_node("Sprite/FillBackground/EmptyFill").color = Color.GHOST_WHITE
				t.tween_property(animationArray[arrayLength - animationIndex - 1].get_node("Sprite/FillBackground/Fill"),"scale:y",animationArray[arrayLength - animationIndex],0.3)
				t.parallel().tween_property(animationArray[arrayLength - animationIndex - 1],"scale",Vector2(1.1,1.1),0.3)
				t.parallel().chain().tween_property(animationArray[arrayLength - animationIndex - 1],"scale",Vector2(1,1),0.3)
				t.tween_property(animationArray[arrayLength - animationIndex - 1].get_node("Sprite/FillBackground/EmptyFill"),"scale:y",animationArray[arrayLength - animationIndex],0.2)
				animationIndex += 2
		else:
			for i in animationCount:
				animationArray[animationIndex].get_node("Sprite/FillBackground/EmptyFill").color = Color.LIME_GREEN
				t.tween_property(animationArray[animationIndex].get_node("Sprite/FillBackground/EmptyFill"),"scale:y",animationArray[animationIndex + 1],0.2)
				t.tween_property(animationArray[animationIndex].get_node("Sprite/FillBackground/Fill"),"scale:y",animationArray[animationIndex + 1],0.3)
				animationIndex += 2
		previousHpState = character.hp
