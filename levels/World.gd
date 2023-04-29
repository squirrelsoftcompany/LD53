extends Node3D


@onready var _pause_canvas := $PauseCanvas


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause_canvas.visible = !_pause_canvas.visible
		get_tree().paused = _pause_canvas.visible


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	Global.goto_main_menu()
