extends Node3D

Vector3 move

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move.z = -1*(Input.get_action_strength("go_back"))
	move += (Input.get_action_strength("go_front"))
	move += (Input.get_action_strength("go_left"))
	move += (Input.get_action_strength("go_right"))
	$RCS.process_material.set("shader_parameter/forceX",move.x)
	$RCS.process_material.set("shader_parameter/forceY",move.y)
	$RCS.process_material.set("shader_parameter/forceZ",move.z)
	pass
