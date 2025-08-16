extends Node2D

@onready var tilemap := $TileMapLayer
#@onready var dude := $Dude

const dudeRef = preload("res://scenes/grid test/dude.tscn")

func _ready() -> void:
	for x in range(-20, 20):
		for y in range(-20, 20):
			var coord = Vector2(x, y)
			var tile = tilemap.get_cell_tile_data(coord)
			if tile and randf() < 0.5:
				var pos = tilemap.map_to_local(coord)
				var gpos = tilemap.to_global(pos)

				var dude = dudeRef.instantiate()
				add_child(dude)
				dude.position = gpos
