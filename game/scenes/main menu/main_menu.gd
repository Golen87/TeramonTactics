extends Control


func _on_grid_pressed() -> void:
	get_tree().change_scene_to_file(&"res://scenes/grid test/grid_test.tscn")

func _on_monster_pressed() -> void:
	get_tree().change_scene_to_file(&"res://scenes/monster test/monster_test.tscn")

func _on_cards_pressed() -> void:
	get_tree().change_scene_to_file(&"res://scenes/cards test/cards_test.tscn")

func _on_attacks_pressed() -> void:
	get_tree().change_scene_to_file(&"res://scenes/attack test/attack_test.tscn")

func _on_animations_pressed() -> void:
	get_tree().change_scene_to_file(&"res://scenes/animations/AnimationsScene.tscn")
