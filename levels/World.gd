extends Node3D

var _current_delivery_time := 30.0

@onready var _hud := $HUD
@onready var _fail_audio_stream := $FailAudioStream
@onready var _delivery_ok_audio_stream := $DeliveryOkAudioStream
@onready var _critical_failure_audio_stream := $CriticalFailureAudioStream
@onready var _victory_audio_stream := $VictoryAudioStream
@onready var _timer_audio_stream := $TimerAudioStream
@onready var _univers := $Univers


func _ready() -> void:
	Global.connect("new_delivery_point", _on_new_delivery_point)
	Global.connect("gameover_timeout", _on_gameover_timeout)
	Global.connect("delivery_timeout", _on_delivery_timeout)
	Global.connect("delivery_ok", _on_delivery_ok)
	Global.connect("gameover_dead", _on_gameover_dead)
	Global.delivery_count = 1
	Global.delivery_total = 10
	Global.delivery_time = 30
	Global.global_time = 90.0


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
	Global.delivery_time = _current_delivery_time
	if Global.delivery_count == Global.delivery_total:
		_victory_audio_stream.play()
		_hud.gameover("Congratulation: All deliveries are completed for today")
	#Global.delivery_count += 1


func _on_delivery_ok() -> void:
	_delivery_ok_audio_stream.play()
	Global.points += _current_delivery_time - Global.delivery_time
	Global.delivery_time = _current_delivery_time
	_timer_audio_stream.stop()
	Global.global_time += 15
	if Global.delivery_count == Global.delivery_total:
		_victory_audio_stream.play()
		_hud.gameover("Congratulation: All deliveries are completed for today")
	Global.delivery_count += 1


func _on_new_delivery_point(delivery_point: Node3D) -> void:
	# Init Todo
	_current_delivery_time = compute_current_delivery_time(delivery_point)
	Global.delivery_time = _current_delivery_time


func compute_current_delivery_time(delivery_point: Node3D) -> float:
	var caracter:Node3D = _univers.get_character()
	return sqrt(delivery_point.global_position.distance_to(caracter.global_position)) * 2.5
