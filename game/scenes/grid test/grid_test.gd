#@tool
class_name Grid extends Node2D


@onready var tilemap: TileMapLayer = $TileMapLayer
@onready var tilemap_highlight = $TileMapHighlight
@onready var camera: Camera2D = $Camera2D

const dudeRef = preload("res://scenes/grid test/dude.tscn")
var dudes: Array[Dude] = []

# { cell_coord: [prev_coord, distance], ... }
var walkable_cells: Dictionary = {}


func _ready() -> void:
	const dude_count = 15
	var cells = tilemap.get_used_cells()
	cells.shuffle()

	for cell in cells.slice(0, dude_count):
		cell = cell as Vector2i
		var tile = tilemap.get_cell_tile_data(cell)
		if tile and randf() < 1.0:
			var pos = tilemap.map_to_local(cell)
			var gpos = tilemap.to_global(pos)

			var dude: Dude = dudeRef.instantiate()
			dudes.append(dude)
			add_child(dude)
			dude.cell = cell
			dude.position = gpos
			dude.clicked.connect(on_monster_clicked)


# Returns a list of nearby cells that are empty
func get_available_cells(cell: Vector2i) -> Array[Vector2i]:
	return tilemap.get_surrounding_cells(cell).filter(is_empty)

class NavCell:
	var cell: Vector2i
	var previous: Vector2i
	var distance: int

	func _init(_cell, _previous, _distance):
		cell = _cell
		previous = _previous
		distance = _distance

# Finds all available cells within max_moves number of steps
func calculate_walkable_cells(start: Vector2i, max_moves: int):
	var queue: Array[Vector2i] = [start]
	walkable_cells = { start: [null, 0] }

	while not queue.is_empty():
		var current = queue.pop_front()
		var distance = walkable_cells[current][1]

		for neighbor in tilemap.get_surrounding_cells(current):
			if neighbor not in walkable_cells and is_monster(neighbor):
				walkable_cells[neighbor] = [current, distance + 1]

		# Skip checking if max_moves reached
		if distance >= max_moves:
			continue

		# Check cell neighbors
		for neighbor in get_available_cells(current):
			if neighbor not in walkable_cells:
				queue.append(neighbor)
				walkable_cells[neighbor] = [current, distance + 1]

# Returns a list of cells that leads to the goal cell
func get_walkable_path(goal_cell):
	var path = [goal_cell]
	var cell = walkable_cells[goal_cell][0]
	while cell:
		path.append(cell)
		cell = walkable_cells[cell][0]
	path.reverse()
	return path

func clear_selection():
	tilemap_highlight.clear()
	walkable_cells = {}
	for dude in dudes:
		dude.selected = false

func move_camera_to(target_position: Vector2) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(camera, "global_position", target_position, 1.0)

func on_monster_clicked(dude: Dude) -> void:
	clear_selection()
	dude.selected = true

	# Center camera on selected dude
	move_camera_to(dude.global_position)

	# Show cells that can be moved to
	var MOVE_DISTANCE = 4 # Replace with monster.action_points
	calculate_walkable_cells(dude.cell, MOVE_DISTANCE)

	for cell in walkable_cells:
		if cell == dude.cell:
			tilemap_highlight.set_cell(cell, 0, Vector2i(3, 0))
		elif get_monster(cell):
			tilemap_highlight.set_cell(cell, 0, Vector2i(2, 0))
		else:
			tilemap_highlight.set_cell(cell, 0, Vector2i(0, 0))

func is_empty(cell: Vector2i) -> bool:
	if tilemap.get_cell_tile_data(cell):
		for dude in dudes:
			if dude.cell == cell:
				return false
		return true
	return false

func is_monster(cell: Vector2i) -> bool:
	if tilemap.get_cell_tile_data(cell):
		for dude in dudes:
			if dude.cell == cell:
				return true
	return false

func get_monster(cell: Vector2i) -> Dude:
	if tilemap.get_cell_tile_data(cell):
		for dude in dudes:
			if dude.cell == cell:
				return dude
	return null

func get_neighboring_monster(cell: Vector2i) -> Dude:
	var monsters = tilemap.get_surrounding_cells(cell).filter(get_monster).map(get_monster)
	if monsters:
		return monsters.pick_random()
	return null

func cell_to_world(cell: Vector2i) -> Vector2:
	return tilemap.to_global(tilemap.map_to_local(cell))

# BUG: This is called before any monster is clicked.
# Monster clicks are later received in on_monster_clicked.
# Figure out a way to get tiles to be clicked after monsters.
func _input(event: InputEvent) -> void:
	event = event as InputEventMouseButton
	if event and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Get mouse position in viewport coordinates and convert to world space through camera
		var viewport = get_viewport()
		var camera = viewport.get_camera_2d()
		var mouse_pos = viewport.get_mouse_position()
		var world_pos = (mouse_pos - viewport.get_visible_rect().size * 0.5) / camera.zoom + camera.global_position

		# Convert world position to local tilemap coordinates
		var local_pos = tilemap.to_local(world_pos)
		var cell = tilemap.local_to_map(local_pos)
		var tile_data = tilemap.get_cell_tile_data(cell)
		if tile_data:
			select_tile(cell)
		else:
			clear_selection()

func get_selected_dude() -> Dude:
	for dude in dudes:
		if dude.selected:
			return dude
	return null

func select_tile(cell: Vector2i):
	prints("Tile clicked!", cell)

	# Clicked on highlighted tile. Move selected dude.
	if walkable_cells.has(cell):
		var dude = get_selected_dude()
		if dude:
			var path: Array[Vector2] = []
			for path_cell in get_walkable_path(cell):
				path.append(cell_to_world(path_cell))
			dude.move_along_path(path)

			# Move camera to final destination
			# move_camera_to(path[-1])

			dude.cell = cell

			clear_selection()
	# Highlight tile
	else:
		clear_selection()
		tilemap_highlight.set_cell(cell, 0, Vector2i(Vector2i(1, 0)))
