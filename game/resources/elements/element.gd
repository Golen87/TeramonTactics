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

static func get_element(type: Type) -> Resource:
	if _resources.is_empty():
		_init_resources()
	return _resources.get(type, null)

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


#func get_element_resource(type: Type):
	#return resources[type]
