extends Control

const MAIN_GAME = preload("res://scenes/levels/test/main.tscn")

signal show_hint_start_game()

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var timer: Timer = $Timer
@onready var hint: Label = $Hint
@onready var timer_hint: Timer = $TimerHint

var hint_tween: Tween
var is_text_skipped: bool = false

var lang = Global.lang

# Текст, который мы хотим напечатать
#var text_to_type = {
	#"rus": """
	#Жертва родителей подарила мне фальшивые документы и шанс выжить в разгар чисток. Годами я прятался у всех на виду под маской верного офицера, но новые проверки прижали меня к стенке. Единственным шансом избежать неминуемой казни стало назначение комендантом в заброшенный лагерь.   
#
	#Я бежал сюда ради спасения, но шагнул в худший кошмар. Смертельная угроза не отступила — она дышит мне в спину каждым шагом и каждым доносом. Здесь, среди ржавой проволоки и чужой агонии, воздух пропитан не только ужасом: сама тьма этого места шепчет о сделках, способных подарить спасение ценой чужих душ.   
#
	#Приказ подписан. И это определенно был ПЛОХОЙ ПЛАН.
	#""",
	#"eng": """
	#My parents sacrificed everything to buy me forged papers and a chance to survive the purges. For years, I hid in plain sight as a dutiful officer, until ruthless audits backed me into a corner. My only desperate escape from the gallows was accepting command over an abandoned camp.   
#
	#I fled here to survive, only to step into an even darker nightmare. Doom is still breathing down my neck, waiting for a single misstep. Yet behind the rusted barbed wire, fear isn't the only thing lingering in the cold: something ancient and unnatural stirs in the shadows, offering salvation in exchange for the souls of the condemned.   
#
	#The order is signed. Truly a BAD PLAN.
	#"""
#}
var text_to_type = {
	"rus": """
    Фальшивые документы скрывали меня годами, но новые чистки прижали к стенке. Чтобы избежать петли, я вызвался комендантом в этот заброшенный лагерь.

    Я искал убежище, но шагнул в кошмар. Смерть всё ещё дышит в спину, а местная тьма предлагает сделку: моё спасение ценой чужих душ.

    Приказ подписан. Это был определенно ПЛОХОЙ ПЛАН.
	""",
	"eng": """
    Forged papers kept me hidden for years, but new purges backed me into a corner. To escape the gallows, I took command of this abandoned camp.

    I sought refuge, but stepped into a nightmare. Doom still breathes down my neck, while the shadows whisper a deal: my salvation for the souls of others.

    The order is signed. Truly a BAD PLAN.
    """
}



func _ready():
	show_hint_start_game.connect(_on_show_hint_start_game)
	
	hint.modulate.a = 0.0 # Изначально делаем надпись прозрачной
	# Инициализируем текст, но скрываем все символы
	rich_text_label.text = text_to_type.get(lang)
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
		
	# Останавливаем таймер, если весь текст напечатан
	if rich_text_label.visible_characters >= rich_text_label.text.length():
		timer.stop()
		is_text_skipped = true # Позволит нажать SPACE, даже если игрок досмотрел текст до конца
		_on_show_hint_start_game()


func _input(event):
	# Если игрок нажимает левую кнопку мыши
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
	if event.is_action_pressed("LBM"):
		is_text_skipped = true
		# Сразу показываем весь текст и останавливаем таймер
		rich_text_label.visible_characters = rich_text_label.text.length()
		timer.stop()
		show_hint_start_game.emit()
	
	if event.is_action_pressed("SPACE") and is_text_skipped:
		print("Переход в игру")
		get_tree().change_scene_to_packed(MAIN_GAME)


func _animate_hint() -> void:
	# Останавливаем предыдущую анимацию, если она была
	if hint_tween:
		hint_tween.kill()
		
	# Создаем бесконечно зацикленный Tween для мигания
	hint_tween = create_tween().set_loops()
	
	# Плавное появление (альфа становится 1.0 за 1 секунду)
	hint_tween.tween_property(hint, "modulate:a", 1.0, 1.0)
	
	# Плавное растворение (альфа становится 0.0 за 1 секунду)
	hint_tween.tween_property(hint, "modulate:a", 0.0, 1.0)


func _on_timer_hint_timeout() -> void:
	_animate_hint()


func _on_show_hint_start_game() -> void:
	hint.text = "Press [Space] to Start"
