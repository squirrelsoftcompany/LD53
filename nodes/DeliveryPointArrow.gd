extends Control


@export var radius_scale := 0.75
@export var target_3d_position : Vector3


@onready var _texture := $%TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var _camera := get_viewport().get_camera_3d()
	var _viewport_rect := get_viewport_rect()
	var _radius := radius_scale * minf(_viewport_rect.size.x, _viewport_rect.size.y)/2
	var _viewport_center := get_viewport_rect().get_center()
	var _target_position := _camera.unproject_position(target_3d_position)
	var _camZ_dot_target := (-_camera.global_transform.basis.z).dot((target_3d_position - _camera.global_position).normalized())
	
	if !_camera.is_position_in_frustum(target_3d_position):
		var _sign_cam_dot_target = (1.0 if _camZ_dot_target > 0.0 else -1.0) # we need to invert arrow if it's behind camera
		var _target_direction : Vector2 = (_target_position - _viewport_center).normalized() * _sign_cam_dot_target
		_texture.visible = true
		_texture.rotation = Vector2.UP.angle_to(_target_direction)
		_texture.position = _viewport_center - _texture.size/2 + _target_direction * _radius
	else:
		_texture.visible = false
