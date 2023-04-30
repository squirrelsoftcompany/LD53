extends Node3D


@onready var _hud := $HUD
@onready var _fail_audio_stream := $FailAudioStream


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
	_hud.gameover("Game Over : Timeout")


func _on_delivery_timeout() -> void:
	_fail_audio_stream.play()
	Global.delivery_time = 30.0
	if Global.delivery_count == Global.delivery_total:
		_hud.gameover("Congratulation: All deliveries are completed for today")
	Global.delivery_count += 1
	# TODO
