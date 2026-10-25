extends Control

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var timer: Timer = $Timer


# Текст, который мы хотим напечатать
var text_to_type = "Привет! Это имитация печатной машинки в Godot 4.\nТекст появляется по одной букве."


func _ready():
	# Инициализируем текст, но скрываем все символы
	rich_text_label.text = text_to_type
	rich_text_label.visible_characters = 0
	
	# Настраиваем и запускаем таймер
	timer.wait_time = 0.116 # Скорость печати (в секундах на одну букву)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _on_timer_timeout():
	# Добавляем один видимый символ
	rich_text_label.visible_characters += 1
	
	# ДОБАВЛЕНО: Получаем символ из строки по его индексу
	var current_char = rich_text_label.text[rich_text_label.visible_characters - 1]

	if current_char != " " and current_char != "\n":
		# Случайная высота тона от 0.9 (чуть ниже) до 1.1 (чуть выше)
		$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.1) 
		$AudioStreamPlayer.play()
	
	# Останавливаем таймер, если весь текст напечатан
	if rich_text_label.visible_characters >= rich_text_label.text.length():
		timer.stop()


func _input(event):
	# Если игрок нажимает левую кнопку мыши
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Сразу показываем весь текст и останавливаем таймер
		rich_text_label.visible_characters = rich_text_label.text.length()
		timer.stop()
