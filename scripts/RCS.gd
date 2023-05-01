extends Node3D


func apply_raw_input(raw_input : Vector3):
	$RCS_left.emitting  = raw_input.x < -0.2
	$RCS_right.emitting = raw_input.x >  0.2
	$RCS_back.emitting  = raw_input.z < -0.2
	$RCS_back2.emitting = raw_input.z < -0.2
	$RCS_down.emitting  = raw_input.y < -0.2
	$RCS_down2.emitting = raw_input.y < -0.2
	$RCS_up.emitting    = raw_input.y >  0.2
	$RCS_up2.emitting   = raw_input.y >  0.2


func apply_jump():
	$RCS_jump.emitting = true
	$RCS_jump2.emitting = true
