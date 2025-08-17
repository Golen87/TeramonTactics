extends Resource
class_name Element


## Element types
enum Type {
	None = 0,
	Blaze,
	Curse,
	Darkness,
	Flourish,
	Freeze,
	Radiance,
	Shatter,
	Shield,
	Spikes,
	Surge,
	Tailwind,
	Tide,
	Veil,
	Venom,
}

enum StatType {
	None,
	Health,
	Attack,
	ActionPoints,
	Fury,
	Speed
}

#var resources = {
	#Type.Blaze: load("res://resources/elements/blaze.tres"),
	#Type.Curse: load("res://resources/elements/curse.tres"),
	#Type.Darkness: load("res://resources/elements/darkness.tres"),
	#Type.Flourish: load("res://resources/elements/flourish.tres"),
	#Type.Freeze: load("res://resources/elements/freeze.tres"),
	#Type.Radiance: load("res://resources/elements/radiance.tres"),
	#Type.Shatter: load("res://resources/elements/shatter.tres"),
	#Type.Shield: load("res://resources/elements/shield.tres"),
	#Type.Spikes: load("res://resources/elements/spikes.tres"),
	#Type.Surge: load("res://resources/elements/surge.tres"),
	#Type.Tailwind: load("res://resources/elements/tailwind.tres"),
	#Type.Tide: load("res://resources/elements/tide.tres"),
	#Type.Veil: load("res://resources/elements/veil.tres"),
	#Type.Venom: load("res://resources/elements/venom.tres"),
#}

static var _resources: Dictionary = {}
static var _stat_resources: Dictionary = {}

static func get_element(type: Type) -> Resource:
	if _resources.is_empty():
		_init_resources()
	return _resources.get(type, null)

static func get_stat(type: StatType) -> Resource:
	if _stat_resources.is_empty():
		_init_stat_resources()
	return _stat_resources.get(type, null)

static func _init_resources():
	_resources = {
		Type.Blaze: load("res://resources/elements/blaze.tres"),
		Type.Curse: load("res://resources/elements/curse.tres"),
		Type.Darkness: load("res://resources/elements/darkness.tres"),
		Type.Flourish: load("res://resources/elements/flourish.tres"),
		Type.Freeze: load("res://resources/elements/freeze.tres"),
		Type.Radiance: load("res://resources/elements/radiance.tres"),
		Type.Shatter: load("res://resources/elements/shatter.tres"),
		Type.Shield: load("res://resources/elements/shield.tres"),
		Type.Spikes: load("res://resources/elements/spikes.tres"),
		Type.Surge: load("res://resources/elements/surge.tres"),
		Type.Tailwind: load("res://resources/elements/tailwind.tres"),
		Type.Tide: load("res://resources/elements/tide.tres"),
		Type.Veil: load("res://resources/elements/veil.tres"),
		Type.Venom: load("res://resources/elements/venom.tres"),
	}

static func _init_stat_resources():
	_stat_resources = {
		StatType.Health: load("res://resources/elements/blaze.tres"),
		StatType.Attack: load("res://resources/elements/curse.tres"),
		StatType.ActionPoints: load("res://resources/elements/darkness.tres"),
		StatType.Fury: load("res://resources/elements/flourish.tres"),
		StatType.Speed: load("res://resources/elements/freeze.tres")
	}


#func get_element_resource(type: Type):
	#return resources[type]
