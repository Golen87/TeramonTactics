class_name Unit extends Node2D

signal clicked

@onready var sprite: UnitSprite = %UnitSprite

@onready var health_badge: NumberedBadge = $HUD/LeftBar/HealthBadge
@onready var attack_badge: NumberedBadge = $HUD/RightBar/AttackBadge
@onready var ap_badge: NumberedBadge = $HUD/BottomBar/APBadge
@onready var fury_badge: NumberedBadge = $HUD/BottomBar/FuryBadge
@onready var status_bar_defensive: VBoxContainer = %StatusBarDefensive
@onready var status_bar_offensive: VBoxContainer = %StatusBarOffensive

@export var unit_data: MonsterDefinition:
	get: return unit_data
	set(value):
		unit_data = value
		_set_unit_data(unit_data)

var mouse_over: bool = false

const STATUS_BADGE_SCENE = preload("res://components/UI/numbered_badge.tscn")


func _ready():
	sprite.mouse_entered.connect(_on_mouse_entered)
	sprite.mouse_exited.connect(_on_mouse_exited)

func _set_unit_data(_unit_data: MonsterDefinition):
	if not is_node_ready(): await ready
	_update_unit_data()
	unit_data.changed.connect(_update_unit_data)
	sprite.play_animation(UnitSprite.UnitAnimation.IDLE)

func _on_mouse_entered():
	mouse_over = true
func _on_mouse_exited():
	mouse_over = false

func _input(event):
	if !mouse_over: return
	
	if event is InputEventMouseButton and event.is_released():
		print("Unit Clicked!")

func _update_unit_data():
	health_badge.amount = unit_data.current_health
	attack_badge.amount = unit_data.current_attack
	ap_badge.amount = unit_data.current_action_points
	fury_badge.amount = unit_data.current_fury
	
	for child in status_bar_defensive.get_children(): 
		child.queue_free()
	for child in status_bar_offensive.get_children(): 
		child.queue_free()
	
	for status in unit_data.statuses.keys():
		var new_badge = STATUS_BADGE_SCENE.instantiate()
		var res: ElementDefinition = Element.get_element(status)
		var target_container = status_bar_offensive if res.is_offensive else status_bar_defensive
		target_container.add_child(new_badge)
		
		new_badge.attribute = res
		new_badge.amount = unit_data.statuses[status]
	pass
