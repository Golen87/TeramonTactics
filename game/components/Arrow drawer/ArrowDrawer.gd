extends Node2D

signal queue_attack(attacker: Monster, defender: Monster)
@onready var line: Line2D = $Line2D

var source_monster: Node = null
var target_monster: Node = null
var dragging := false
var mouse_pos := Vector2.ZERO

var monsters: Array[Monster]


func _ready():
	monsters.assign(get_tree().get_nodes_in_group(&"monster"))
	for monster in monsters:
		monster.drag_started.connect(_on_drag_start)
		monster.drag_ended.connect(_on_drag_stop)


func _on_drag_start(monster: Monster):
	source_monster = monster
	dragging = true


func _process(_delta: float):
	if dragging:
		# Snap to a target if hovering
		target_monster = null
		for other in monsters:
			if other == source_monster:
				continue
			if other.is_hovered:
				target_monster = other
				break

		mouse_pos = get_viewport().get_mouse_position()
		_draw()


func _on_drag_stop(_monster: Monster):
	mouse_pos = get_global_mouse_position()

	if dragging:
		dragging = false
		if target_monster != null:
			queue_attack.emit(source_monster, target_monster)
		source_monster = null
		target_monster = null
		_draw()


func _draw():
	if not dragging or source_monster == null:
		line.clear_points()
		return

	var from = source_monster.global_position
	var to = mouse_pos
	if target_monster != null:
		to = target_monster.global_position

	var center := get_viewport_rect().get_center()
	var control_point: Vector2 = (from + to + 2 * center) / 4

	var curve := Curve2D.new()

	curve.add_point(from)
	curve.add_point(to, control_point - to, Vector2.ZERO)

	line.clear_points()
	for point in curve.get_baked_points():
		line.add_point(point)
