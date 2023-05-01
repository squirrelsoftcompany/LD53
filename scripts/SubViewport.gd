extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await RenderingServer.frame_post_draw
	$"../Sprite3D".texture = get_texture()
