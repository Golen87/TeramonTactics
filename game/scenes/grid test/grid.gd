@tool
class_name CustomTileLayer extends TileMapLayer

@export var layer_height: int
var origin: Vector2i
@export var dimensions: Vector2i
@export var amount_range: Vector2i = Vector2i(-1, -1)
@export var height_random: int
@export var eligible_tiles: Array[Vector2i]

var elevation_raise: float = 1.0
var elevations: Dictionary = {}
var origins: Dictionary = {}
var funny: Dictionary = {}

const TILE_SIZE: Vector2i = Vector2i(128, 64)

func _use_tile_data_runtime_update(coords) -> bool:
	return false

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if origins.has(coords):
		tile_data.texture_origin = origins[coords]

func _ready():
	var cells = get_used_cells()
	for cell_coords in cells:
		var data: TileData = get_cell_tile_data(cell_coords)
		funny[cell_coords] = 1.4 * Vector2(cell_coords.x - 5, cell_coords.y - 5).length()
		origins[cell_coords] = Vector2()

var time = 0
func _process(delta: float) -> void:
	time += 2 * delta
	for cell_coords in funny.keys():
		origins[cell_coords].y = max(0, 30 * sin(-time + funny[cell_coords]))
	notify_runtime_tile_data_update()
