extends Node2D

@onready var unit: Unit = %Zorua
@onready var timer = %Timer

func _ready():
	timer.timeout.connect(anim)
	timer.start()
	
func anim():
	var rand = randi_range(0, len(UnitSprite.UnitAnimation.values()) - 1)
	unit.sprite.play_animation(rand)
