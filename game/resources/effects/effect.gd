extends Resource
class_name Effect


## What unit the effect should target
@export var target: Target = Target.Self

## When the effect is triggered
@export var when: When = When.BeforeAttack


enum Target {
	Self,
	Other,
	RandomAlly,
	RandomEnemy,
}

enum When {
	BeforeAttack,
	AfterAttack,
	BeforeDamage,
	AfterDamage,
	BeforeHeal,
	AfterHeal,
	EndOfTurn
}
