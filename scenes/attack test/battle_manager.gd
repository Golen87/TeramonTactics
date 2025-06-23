extends Node

@onready var arrow_drawer := $ArrowDrawer


func _ready():
	arrow_drawer.queue_attack.connect(_on_attack)


const blaze = preload("res://resources/elements/blaze.tres")

func _on_attack(attacker: Monster, defender: Monster):
	var damage: int = attacker.attack

	for effect in attacker.get_effect_stack():
		if effect.used:
			continue
		if effect.element == blaze:
			damage += 1
			effect.used = true

	_on_damage(damage, defender, attacker)

func _on_damage(damage: int, defender: Monster, attacker: Monster):
	prints(defender, "receives", damage, "damage from", attacker)
	#for i in range(attacker.stacked_effects.size() - 1, -1, -1):
		#var effect := attacker.stacked_effects[i]
		#if effect == blaze:
			#damage -= 1
			#attacker.remove_stack_effect(i)

	defender.health -= damage
