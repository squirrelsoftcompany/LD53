extends Control


func _on_new_game_pressed() -> void:
	Global.play_validate()
	Global.goto_world()


func _on_exit_pressed() -> void:
	Global.play_validate()
	get_tree().quit()

