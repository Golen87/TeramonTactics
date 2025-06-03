extends Control


func _on_grid_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/grid_test.tscn")

func _on_monster_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/monster_test.tscn")

func _on_cards_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cards_test.tscn")
