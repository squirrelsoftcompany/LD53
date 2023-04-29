extends Node


signal gameover_timeout
signal gameover_dead


var _current_scene: Node = null
var _is_gameover := false
var _main_menu := preload("res://levels/ui/MainMenu.tscn")
var _overworld := preload("res://levels/Overworld.tscn")


func _ready() -> void:
	var root = get_tree().get_root()
	_current_scene = root.get_child(1)


func reload_current_scene() -> void:
	reinit()
	var _return_val := get_tree().reload_current_scene()


func goto_overworld() -> void:
	_goto_scene(_overworld)


func goto_main_menu() -> void:
	_goto_scene(_main_menu)


func _goto_scene(scene: Resource) -> void:
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.
	
	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", scene)


func _deferred_goto_scene(scene: Resource) -> void:
	# Remove the current scene
	if _current_scene:
		_current_scene.free()

	# Instance the new scene.
	_current_scene = scene.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(_current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(_current_scene)
	
	# Reinit global data
	reinit()


func reinit() -> void:
	_is_gameover = false


func dead() -> void:
	if not _is_gameover:
		emit_signal("gameover_dead")
		_is_gameover = true


func timeout() -> void:
	if not _is_gameover:
		emit_signal("gameover_timeout")
		_is_gameover = true
