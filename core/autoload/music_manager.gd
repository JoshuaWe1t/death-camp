extends Node

@export var playlist: Array[AudioStream]
@export var fade_duration: float = 2.0 # Время плавного перехода в секундах

@onready var player_a: AudioStreamPlayer = $PlayerA
@onready var player_b: AudioStreamPlayer = $PlayerB

var current_track_index: int = 0
var active_player: AudioStreamPlayer

func _ready() -> void:
	active_player = player_a
	# Подключаем сигналы окончания трека для зацикливания плейлиста
	player_a.finished.connect(_on_track_finished)
	player_b.finished.connect(_on_track_finished)

# Запуск стандартного плейлиста
func start_playlist() -> void:
	if playlist.is_empty(): return
	_crossfade_to_stream(playlist[current_track_index])

# Переход к следующему треку (вызывается автоматически при окончании)
func _on_track_finished() -> void:
	if playlist.is_empty(): return
	
	current_track_index = (current_track_index + 1) % playlist.size()
	_crossfade_to_stream(playlist[current_track_index])

# Вызов конкретного трека по индексу из массива (например, из другого скрипта)
func play_specific_track(index: int) -> void:
	if index >= 0 and index < playlist.size():
		current_track_index = index
		_crossfade_to_stream(playlist[current_track_index])

# Логика плавного перехода (кроссфейд)
func _crossfade_to_stream(stream: AudioStream) -> void:
	# Определяем, какой плеер сейчас свободен
	var next_player = player_b if active_player == player_a else player_a
	
	next_player.stream = stream
	next_player.volume_db = -80.0 # Начинаем с полной тишины
	next_player.play()
	
	# Создаем Tween для плавного изменения громкости
	var tween = get_tree().create_tween().set_parallel(true)
	
	# Заглушаем текущий трек (если он играет)
	if active_player.playing:
		tween.tween_property(active_player, "volume_db", -80.0, fade_duration)
	
	# Увеличиваем громкость нового трека до 0.0 (базовый уровень)
	tween.tween_property(next_player, "volume_db", 0.0, fade_duration)
	
	# После завершения анимации останавливаем старый плеер
	tween.chain().tween_callback(active_player.stop)
	
	active_player = next_player
