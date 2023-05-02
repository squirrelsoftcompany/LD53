extends Node
class_name GlobalData


signal delivery_ok
signal delivery_timeout
signal new_delivery_point(delivery_point : Node3D)
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
var current_delivery_point : Node3D = null

var _global_stream_player := AudioStreamPlayer.new()
var _validate_sound := preload("res://audio/select.wav")
var _current_scene: Node = null
var _is_gameover := false
var _main_menu := preload("res://levels/ui/MainMenu.tscn")
var _world := preload("res://levels/World.tscn")
var _rng
var rng_seed : int

#Delivery zones loading
var deliveryZone_1 := preload("res://nodes/buildings/2_lvl_square.tscn")
var deliveryZone_2 := preload("res://nodes/buildings/3_lvl_square.tscn")
var deliveryZone_3 := preload("res://nodes/buildings/small/dumpster.tscn")
var deliveryZone_4 := preload("res://nodes/buildings/small/locker.tscn")
var deliveryZone_5 := preload("res://nodes/buildings/small/mail_box.tscn")
var globalDeliveryZoneAssetArray = [deliveryZone_1,deliveryZone_2,deliveryZone_3,deliveryZone_4,deliveryZone_5]
#Punchable loading
var punchable_1 := preload("res://nodes/punchable/ad_panel.tscn")
var punchable_2 := preload("res://nodes/punchable/bin.tscn")
var globalPunchableAssetArray = [punchable_1,punchable_2,]


func play_validate() -> void:
	play_sound(_validate_sound)


func play_sound(sound: AudioStream) -> void:
	if not _global_stream_player.playing:
		_global_stream_player.stream = sound
		_global_stream_player.play()

func _init() -> void:
	rng_seed = randi()
	_rng = RandomNumberGenerator.new()
	
func _ready() -> void:
	var root = get_tree().get_root()
	_current_scene = root.get_child(1)
	_rng.set_seed(rng_seed)
	_global_stream_player.process_mode = PROCESS_MODE_ALWAYS
	add_child(_global_stream_player)


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
	Engine.time_scale = 1.0
	current_delivery_point = null
	_select_next_delivery_point()


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
		_select_next_delivery_point()


func delivery_success() -> void:
	if not _is_gameover:
		emit_signal("delivery_ok")
		_select_next_delivery_point()


func _select_next_delivery_point() -> void:
	if current_delivery_point:
		current_delivery_point.disactivate()
	
	var planets := get_tree().get_nodes_in_group("Planet")
	var facilities := []
	for planet in planets:
		facilities.append_array( planet.facilitiesArray )
	if facilities.size() != 0:
		facilities.erase(current_delivery_point)
		current_delivery_point = facilities[randi_range(0, facilities.size()-1)]
		current_delivery_point.activate()
		emit_signal("new_delivery_point", current_delivery_point)
	else:
		@warning_ignore("assert_always_false")
		assert(false)
