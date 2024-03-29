extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return
	look_at(camera.global_transform.origin)
	var dist = camera.global_transform.origin.distance_to(self.global_position)/15
	dist = pow(dist,0.8)
	if dist <= 1:
		dist=1
	self.set_scale(Vector3(dist,dist,dist))
	pass
