extends Node3D
class_name GasEmitter

enum Upgrade {LEVEL_1, LEVEL_2, LEVEL_3}

const GAS_EMMITOR = preload("res://Assets/ui/gas_emmitor.tres")

@export var entity_detector: EntityDetectArea

@export var velocity: float = 24
## Modify the [param entity_detector] size when upgrading to the next level. [br]
## Default sizes are 8.0, 15.0, 20.0
@export var gas_ranges: Dictionary[Upgrade, float]

@export var visuals_per_level: Dictionary[Upgrade, MeshInstance3D]

@export var particle_emitters: Dictionary[Upgrade, GPUParticles3D]

var current_level: Upgrade = Upgrade.LEVEL_1

var current_emitter: GPUParticles3D

func _ready() -> void:
	_update_gas_range(current_level)
	if gas_ranges.is_empty():
		printerr("Gas Ranges from 'gas emmitor' is empty")
	if visuals_per_level.is_empty():
		printerr("Visuals Per Level from 'gas emmitor' is empty")
	if particle_emitters.is_empty():
		printerr("Particul Emitters from 'gas emmitor' is empty")

func _update_gas_range(level: Upgrade) -> void:
	current_level = level
	var collision_radius: float = entity_detector.collision.shape.radius
	collision_radius = gas_ranges[current_level]
	for i in visuals_per_level:
		var visual: MeshInstance3D = visuals_per_level[i]
		if i == current_level:
			visual.visible = true
		else:
			visual.visible = false
	current_emitter = particle_emitters[current_level]
