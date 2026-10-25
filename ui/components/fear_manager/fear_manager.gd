extends Node

@onready var audio_player: AudioStreamPlayer = $HeartbeatAudio

var max_staff: int = 31 # Базовое количество сотрудников без игрока
var beats_to_play: int = 0
var current_beats: int = 0
var beat_pause: float = 0.0 # Время задержки между ударами

func _ready() -> void:
	EventBus.day_started.connect(_on_day_started)
	audio_player.finished.connect(_on_audio_finished)


func _on_day_started(_day: int) -> void:
	await get_tree().process_frame
	_calculate_and_play_heartbeat()


func _calculate_and_play_heartbeat() -> void:
	var processed_count: int = 0
	var unchecked_count: int = 0
	
	# Считаем проверенных и оставшихся сотрудников[cite: 6]
	for member in StaffManager.staff_list:
		if not member.is_player:
			if member.is_checked or member.is_neutralized or member.is_skipped:
				processed_count += 1
			else:
				unchecked_count += 1
				
	var tension: float = 0.0
	if max_staff > 5:
		var max_tension_threshold = max_staff - 5
		tension = clamp(float(processed_count) / float(max_tension_threshold), 0.0, 1.0)
	else:
		tension = 1.0
		
	audio_player.volume_db = lerp(-20.0, 0.0, tension)
	audio_player.pitch_scale = lerp(1.0, 1.6, tension)
	
	var current_beat_duration: float = 0.58 / audio_player.pitch_scale
	var max_beats_in_3_sec: int = floor(3.0 / current_beat_duration)
	
	beats_to_play = int(round(lerp(1.0, float(max_beats_in_3_sec), tension)))
	
	if unchecked_count < 5:
		beats_to_play = max_beats_in_3_sec
		
	# --- Расчет паузы между ударами ---
	if unchecked_count > 10:
		# Пауза плавно сокращается от 0.6 сек (на старте игры) до 0.0 сек (при 10 сотрудниках)
		var pause_factor: float = float(unchecked_count - 10) / float(max_staff - 10)
		beat_pause = lerp(0.0, 0.6, pause_factor)
	else:
		# Меньше или равно 10 сотрудникам — задержки нет, звучит слитно
		beat_pause = 0.0 
		
	current_beats = 0
	
	if beats_to_play > 0:
		_play_next_beat()


func _play_next_beat() -> void:
	current_beats += 1
	audio_player.play()


func _on_audio_finished() -> void:
	if current_beats < beats_to_play:
		if beat_pause > 0.0:
			# Создаем таймер на лету и ждем его завершения перед следующим ударом
			await get_tree().create_timer(beat_pause).timeout
			
		_play_next_beat()
