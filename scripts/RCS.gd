extends Node3D

var initialThrust 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var move = Vector3(0,0,0)
	move.z = (Input.get_action_strength("go_back"))
	move.z += -1*(Input.get_action_strength("go_front"))
	move.x += -1*(Input.get_action_strength("go_left"))
	move.x += (Input.get_action_strength("go_right"))
	move.y += Input.get_action_strength("go_down")
	move.y += -1*(Input.get_action_strength("go_up"))
	$"../../Load/engines".position.z = move.z/5
	if move.distance_to(Vector3(0,0,0)):
		move = to_global(move)
	$RCS.process_material.set("shader_parameter/forceX",move.x)
	$RCS.process_material.set("shader_parameter/forceY",move.y)
	$RCS.process_material.set("shader_parameter/forceZ",move.z)
	pass
