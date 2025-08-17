#@tool
class_name Grid extends Node2D


@onready var tilemap: TileMapLayer = $TileMapLayer
@onready var tilemap_highlight = $TileMapHighlight

const dudeRef = preload("res://scenes/grid test/dude.tscn")
var dudes: Array[Dude] = []

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

# Finds all available cells within max_moves number of steps
func get_reachable_cells(start: Vector2i, max_moves: int) -> Array[Vector2i]:
	var frontier: Array[Vector2i] = [start]
	var visited: = { start: 0 }  # Dictionary: cell -> distance
	var result: Array[Vector2i] = []

	while not frontier.is_empty():
		var current = frontier.pop_front()
		var dist = visited[current]

		# Skip checking if max_moves reached
		if dist >= max_moves:
			continue

		# Check cell neighbors
		for neighbor in get_available_cells(current):
			if neighbor not in visited:
				visited[neighbor] = dist + 1
				frontier.append(neighbor)
				result.append(neighbor)

	return result

func clear_selection():
	tilemap_highlight.clear()
	for dude in dudes:
		dude.selected = false

func on_monster_clicked(dude: Dude) -> void:
	clear_selection()
	dude.selected = true

	# Show cells that can be moved to
	var MOVE_DISTANCE = 3 # Replace with monster.action_points
	var available_cells = get_reachable_cells(dude.cell, MOVE_DISTANCE)
	for cell in available_cells:
		tilemap_highlight.set_cell(cell, 0, Vector2i(0, 0))

func is_empty(cell: Vector2i) -> bool:
	if tilemap.get_cell_tile_data(cell):
		for dude in dudes:
			if dude.cell == cell:
				return false
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
		var local_pos = to_local(event.position)
		var cell = tilemap.local_to_map(local_pos)
		var tile_data = tilemap.get_cell_tile_data(cell)
		if tile_data:
			select_tile(cell)
		else:
			tilemap_highlight.clear()

func select_tile(cell: Vector2i):
	prints("Tile clicked!", cell)

	# Clicked on highlighted tile. Move selected dude.
	if tilemap_highlight.get_cell_tile_data(cell):
		tilemap_highlight.clear()
		for dude in dudes:
			if dude.selected:
				dude.cell = cell
				dude.move(cell_to_world(cell))
				break
	# Highlight tile
	else:
		tilemap_highlight.clear()
		tilemap_highlight.set_cell(cell, 0, Vector2i(Vector2i(1, 0)))
