class_name MyTileMap extends TileMapLayer

var is_selected: Dictionary = {}


# This is potentially performance heavy. Switch to using separate overlay sprites instead.
func _use_tile_data_runtime_update(_coord) -> bool:
	return true

func _tile_data_runtime_update(coord: Vector2i, tile_data: TileData) -> void:
	if is_selected.has(coord) and is_selected[coord]:
		tile_data.modulate = 0xff0000ff
	else:
		var odd = (coord.x + coord.y) % 2
		tile_data.modulate = 0xffffffff if odd else 0xddddddff
