extends Node

@onready var arrow_drawer := $ArrowDrawer


func _ready():
	arrow_drawer.queue_attack.connect(_on_attack)


const blaze = preload("res://resources/types/blaze.tres")

func _on_attack(attacker: Monster, defender: Monster):
	var attack_power: int = attacker.attack
	for i in range(attacker.stacked_effects.size() - 1, -1, -1):
		var effect := attacker.stacked_effects[i]
		if effect == blaze:
			attack_power += 1
			attacker.remove_stack_effect(i)

	defender.health -= attack_power
