extends Node3D
class_name PlayerActionBase
## To emit when a new animation should be triggered. [br]
## Tell to the listener:[br][param new_state]: action single keyword -> for humans to understand the origin,[br]
## [param new_anims]: the list of animations -> in case one action can trigger various animations contextually,[br]
## [param anim_index]: the index of the animation to use from [param new_anims], [br]
## [param is_interruptible]: can this animation be interrupted while playing.
signal state_changed(new_state: String, new_anims: Array[Animation], anim_index: int, is_interruptible: bool)

## The list of animations that this component can trigger.[br]Used in [signal PlayerActionBase.state_changed].
@export
var animations: Array[Animation]

func _can_perform_action() -> bool:
	return false;

func _perform_action() -> void:
	pass;
