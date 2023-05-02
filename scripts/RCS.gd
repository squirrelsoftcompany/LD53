extends Node3D


var _boost_tween : Tween = null


func apply_raw_input(raw_input : Vector3):
	$RCS_left.emitting  = raw_input.x < -0.2
	$RCS_right.emitting = raw_input.x >  0.2
	$RCS_back.emitting  = raw_input.z < -0.2
	$RCS_back2.emitting = raw_input.z < -0.2
	$RCS_down.emitting  = raw_input.y < -0.2
	$RCS_down2.emitting = raw_input.y < -0.2
	$RCS_up.emitting    = raw_input.y >  0.2
	$RCS_up2.emitting   = raw_input.y >  0.2
	$"../../Load/engines".position.z = -raw_input.z/5


func apply_jump():
	$RCS_jump.emitting = true
	$RCS_jump2.emitting = true


func apply_boost():
	if _boost_tween and _boost_tween.is_valid():
		_boost_tween.stop()
	else:
		_boost_tween = get_tree().create_tween()
		_boost_tween.tween_property($"../../Load/engines", "scale", Vector3(0.5, 0.5, 0.5), 1)

	$"../../Load/engines".scale.z = 1.5
	_boost_tween.play()
