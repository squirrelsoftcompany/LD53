extends Node
class_name GlobalData


signal delivery_timeout
signal gameover_timeout
signal gameover_dead


var points := 0
var delivery_count := 0.0
var delivery_total := 0.0
var delivery_time := 0.0:
	set(new_value):
		delivery_time = new_value if new_value > 0.0 else 0.0
		if delivery_time <= 0.0:
			delivery_mised()
var global_time := 0.0:
	set(new_value):
		global_time = new_value if new_value > 0.0 else 0.0
		if global_time <= 0.0:
			timeout()

var _current_scene: Node = null
var _is_gameover := false
var _main_menu := preload("res://levels/ui/MainMenu.tscn")
var _world := preload("res://levels/World.tscn")
var _rng = RandomNumberGenerator.new()
var rng_seed : int = 0

#Facilities loading
var facility_1 := preload("res://nodes/buildings/2_lvls_buildings.tscn")
var facility_2 := preload("res://nodes/buildings/3_lvls_buildings.tscn")
var _globalFacilitiesArray = [facility_1,facility_2]


func _ready() -> void:
	var root = get_tree().get_root()
	_current_scene = root.get_child(1)
	_rng.set_seed(rng_seed)


func goto_world() -> void:
	_goto_scene(_world)


func goto_main_menu() -> void:
	_goto_scene(_main_menu)


func _goto_scene(scene: Resource) -> void:
	# Defer the load to a later time, when
	# we can be sure that no code from the current scene is running
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
	get_tree().paused = false


func dead() -> void:
	if not _is_gameover:
		emit_signal("gameover_dead")
		_is_gameover = true


func timeout() -> void:
	if not _is_gameover:
		emit_signal("gameover_timeout")
		_is_gameover = true


func delivery_mised() -> void:
	if not _is_gameover:
		emit_signal("delivery_timeout")

