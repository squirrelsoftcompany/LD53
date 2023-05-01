extends Node3D


@onready var _hud := $HUD
@onready var _fail_audio_stream := $FailAudioStream
@onready var _delivery_ok_audio_stream := $DeliveryOkAudioStream
@onready var _critical_failure_audio_stream := $CriticalFailureAudioStream
@onready var _victory_audio_stream := $VictoryAudioStream
@onready var _timer_audio_stream := $TimerAudioStream


func _ready() -> void:
	# Init TODO
	Global.delivery_count = 1
	Global.delivery_total = 10
	Global.delivery_time = 30.0
	Global.global_time = 90.0
	Global.connect("gameover_timeout", _on_gameover_timeout)
	Global.connect("delivery_timeout", _on_delivery_timeout)
	Global.connect("delivery_ok", _on_delivery_ok)
	Global.connect("gameover_dead", _on_gameover_dead)


func _process(delta: float) -> void:
	Global.delivery_time = Global.delivery_time - delta
	Global.global_time = Global.global_time - delta
	if Global.global_time <= 12 or Global.delivery_time <= 12:
		if not _timer_audio_stream.playing:
			_timer_audio_stream.play()
			_timer_audio_stream.seek(12 - min(Global.global_time, Global.delivery_time))


func _on_gameover_dead() -> void:
	_hud.gameover("Game Over: You are burning in hell")
	_critical_failure_audio_stream.play()


func _on_gameover_timeout() -> void:
	_hud.gameover("Game Over: Timeout")
	_critical_failure_audio_stream.play()


func _on_delivery_timeout() -> void:
	_fail_audio_stream.play()
	Global.delivery_time = 30.0
	if Global.delivery_count == Global.delivery_total:
		_victory_audio_stream.play()
		_hud.gameover("Congratulation: All deliveries are completed for today")
	Global.delivery_count += 1


func _on_delivery_ok() -> void:
	_delivery_ok_audio_stream.play()
	Global.delivery_time = 30.0
	_timer_audio_stream.stop()
	if Global.delivery_count == Global.delivery_total:
		_victory_audio_stream.play()
		_hud.gameover("Congratulation: All deliveries are completed for today")
	Global.delivery_count += 1
