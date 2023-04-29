extends CanvasLayer


@onready var _delivery_count := $HUDContainer/DeliveryInfoContainer/DeliveryCount
@onready var _delivery_timer := $HUDContainer/DeliveryInfoContainer/DeliveryTimer
@onready var _global_timer := $HUDContainer/InfoContainer/GlobalTimer
@onready var _gameover_data := $GameMenuContainer/GameOverData
@onready var _game_menu := $GameMenuContainer


func _process(_delta: float) -> void:
	if not get_tree().paused:
		_delivery_count.text = "Delivery " + str(Global.delivery_count) + "/" + str(Global.delivery_total)
		_delivery_timer.text = "(" + str(ceil(Global.delivery_time)) + ")"
		var second = int(ceil(Global.global_time)) % 60
		var minute = (int(ceil(Global.global_time)) - second) / 60.0
		_global_timer.text = "Remaining time " + str(minute) + ":" + str(second)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_game_menu.visible = !_game_menu.visible
		get_tree().paused = _game_menu.visible


func _on_main_menu_pressed() -> void:
	_gameover_data.visible = false
	_game_menu.visible = false
	Global.goto_main_menu()


func _on_restart_pressed() -> void:
	_gameover_data.visible = false
	_game_menu.visible = false
	Global.goto_world()


func _on_quit_pressed() -> void:
	get_tree().quit()


func gameover() -> void:
	get_tree().paused = true
	_game_menu.visible = true
	_gameover_data.visible = true
