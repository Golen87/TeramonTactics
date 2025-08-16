extends Node

@onready var arrow_drawer := $ArrowDrawer


class AttackState:
	func _init() -> void:
		self.damage_to_defender = 0
		self.damage_to_attacker = 0

	func _to_string() -> String:
		return "<AttackState %f>" % self.damage_to_defender

func new_attack_state():
	return {
		"damage_to_defender": 0,
		"damage_to_attacker": 0,
	}


func _ready():
	arrow_drawer.queue_attack.connect(_on_attack)

	#var test := AttackState.instantiate()
	#var test = new_attack_state()
	#print(test)


func _on_attack(attacker: Monster, defender: Monster):
	trigger_effects(Effect.When.BeforeAttack, attacker, defender)

	var damage: int = attacker.attack

	# Apply element effects
	for effect in attacker.get_effect_stack():
		if effect.used:
			continue
		if effect.element.type == Element.Type.Blaze:
			damage += 1
			effect.used = true

	_on_damage(damage, defender, attacker)

	trigger_effects(Effect.When.AfterAttack, attacker, defender)

func _on_damage(damage: int, defender: Monster, attacker: Monster):
	trigger_effects(Effect.When.BeforeDamage, attacker, defender)

	prints(attacker, "deals", damage, "damage to", defender)
	#for i in range(attacker.stacked_effects.size() - 1, -1, -1):
		#var effect := attacker.stacked_effects[i]
		#if effect == blaze:
			#damage -= 1
			#attacker.remove_stack_effect(i)
	for effect in defender.get_effect_stack():
		match effect.element.type:
			Element.Type.Veil:
				print("cancels attack")
			Element.Type.Shield:
				damage -= 1
			Element.Type.Tide:
				damage += 1
				_on_heal(1, attacker)
				print("increases damage, trigger a new healing call")
			Element.Type.Spikes:
				if attacker:
					_on_damage(1, attacker, null)
			Element.Type.Shatter:
				damage += 1
			Element.Type.Curse:
				damage *= 2

	defender.health -= damage

	if damage > 0:
		trigger_effects(Effect.When.AfterDamage, attacker, defender)


func _on_heal(amount: int, target: Monster):
	trigger_effects(Effect.When.BeforeHeal, target, null)
	target.health += amount
	trigger_effects(Effect.When.AfterHeal, target, null)


func trigger_effects(when: Effect.When, attacker: Monster, defender: Monster):
	prints("Get_effect of", attacker, when)
	var effects := attacker.get_effects(when)
	for effect in effects:
		var target: Monster
		if effect.target == Effect.Target.Self:
			target = attacker
		elif effect.target == Effect.Target.Other:
			target = defender
		if target:
			if effect is ApplyAttack:
				prints("Buff", target, "by", effect.amount, "attack")
			elif effect is ApplyHealth:
				prints("Buff", target, "by", effect.amount, "health")
			elif effect is ApplyToken:
				prints("Apply", effect.amount, effect.element, "tokens to", target)
				target.add_stack_effect(Element.get_element(effect.element))
