extends Control


func _on_new_game_pressed() -> void:
	Global.goto_overworld()


func _on_exit_pressed() -> void:
	get_tree().quit()
