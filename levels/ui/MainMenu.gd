extends Control


func _ready() -> void:
	get_tree().paused = true
	Engine.time_scale = 0.0


func _on_new_game_pressed() -> void:
	Global.play_validate()
	Global.goto_world()
	Engine.time_scale = 1.0


func _on_exit_pressed() -> void:
	Global.play_validate()
	get_tree().quit()

