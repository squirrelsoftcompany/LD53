extends CanvasLayer


var _delivery_points := 0

@onready var _delivery_count := $HUDContainer/DeliveryInfoContainer/DeliveryCount
@onready var _delivery_timer := $HUDContainer/DeliveryInfoContainer/DeliveryTimer
@onready var _global_timer := $HUDContainer/InfoContainer/GlobalTimer
@onready var _gameover_data := $GameMenuContainer/GameOverData
@onready var _game_menu := $GameMenuContainer
@onready var _game_over_label := $GameMenuContainer/GameOverData/GameOver
@onready var _game_over_points_label := $GameMenuContainer/GameOverData/Points
@onready var _points_label := $HUDContainer/PointsContainer/Points


func _process(_delta: float) -> void:
	if not get_tree().paused:
		_delivery_count.text = "Delivery " + str(Global.delivery_count) + "/" + str(Global.delivery_total)
		_delivery_timer.text = "(" + str(ceil(Global.delivery_time)) + ")"
		var second = int(ceil(Global.global_time)) % 60
		var minute = (int(ceil(Global.global_time)) - second) / 60.0
		_global_timer.text = "Remaining time " + str(minute) + ":" + str(second)
		_points_label.text = "Points " + str(int(ceil(Global.global_time)) + Global.points)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_game_menu.visible = !_game_menu.visible
		get_tree().paused = _game_menu.visible
		Engine.time_scale = 0.0 if _game_menu.visible else 1.0


func _on_main_menu_pressed() -> void:
	_gameover_data.visible = false
	_game_menu.visible = false
	Global.play_validate()
	Global.goto_main_menu()


func _on_restart_pressed() -> void:
	_gameover_data.visible = false
	_game_menu.visible = false
	Global.play_validate()
	Global.goto_world()


func _on_quit_pressed() -> void:
	Global.play_validate()
	get_tree().quit()


func gameover(why: String) -> void:
	get_tree().paused = true
	Engine.time_scale = 0.0
	_game_menu.visible = true
	_gameover_data.visible = true
	_game_over_label.text = why
	_game_over_points_label.text = "Points : " + str(int(ceil(Global.global_time)) + Global.points)
