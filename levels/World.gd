extends Node3D


@onready var _hud := $HUD


func _ready() -> void:
	# Init TODO
	Global.delivery_count = 1
	Global.delivery_total = 10
	Global.delivery_time = 30.0
	Global.global_time = 90.0
	Global.connect("gameover_timeout", _on_gameover_timeout)
	Global.connect("delivery_timeout", _on_delivery_timeout)


func _process(delta: float) -> void:
	Global.delivery_time = Global.delivery_time - delta
	Global.global_time = Global.global_time - delta


func _on_gameover_timeout() -> void:
	_hud.gameover()


func _on_delivery_timeout() -> void:
	print("LOUPED")
	# TODO
