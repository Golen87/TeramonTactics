#@tool
class_name Grid extends Node2D


@onready var tilemap: MyTileMap = $TileMapLayer

const dudeRef = preload("res://scenes/grid test/dude.tscn")
var dudes: Array[Dude] = []

func _ready() -> void:
	const dude_count = 12
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
			dude.grid = self
			dude.cell = cell
			dude.position = gpos
			dude.clicked.connect(on_monster_clicked)


func get_available_cells(dude: Dude) -> Array[Vector2i]:
	return tilemap.get_surrounding_cells(dude.cell).filter(is_empty)

func on_monster_clicked(dude: Dude) -> void:
	select_tile(dude.cell)

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
	return tilemap.get_surrounding_cells(cell).filter(get_monster).map(get_monster).pick_random()

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

func select_tile(cell: Vector2i):
	for other_cell in tilemap.get_used_cells():
		tilemap.is_selected[other_cell as Vector2i] = false
	tilemap.is_selected[cell] = true

	prints("Tile clicked!", cell)
	tilemap.notify_runtime_tile_data_update()
