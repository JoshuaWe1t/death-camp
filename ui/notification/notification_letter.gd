extends CanvasLayer

@onready var admit_button: TextureButton = $Control/TextureRect/AdmitButton
@onready var introduction: Label = $Control/TextureRect/MarginContainerIntro/Introduction
@onready var main_part: Label = $Control/TextureRect/MarginContainerMainPart/MainPart
@onready var conclusion: Label = $Control/TextureRect/MarginContainerConclusion/Conclusion
@onready var hint: Label = $Control/Hint

var hint_tween: Tween
var lang: String = "eng"
var commandant: String = "Nicola Costa"

func _ready() -> void:
	hide()
	hint.modulate.a = 0.0 # Изначально делаем надпись прозрачной
	
	# Подключаем сигнал, который срабатывает при вызове show() или hide()
	visibility_changed.connect(_on_visibility_changed)
	
	admit_button.pressed.connect(_on_admit_button_pressed)
	
	EventBus.game_started.connect(_on_game_started)
	EventBus.supervisor_arrived.connect(_on_superviser_arrived)


func _on_visibility_changed() -> void:
	if visible:
		_start_hint_sequence()
	else:
		# Сброс состояния, если сцену скрыли (hide)
		hint.modulate.a = 0.0
		if hint_tween:
			hint_tween.kill()


func _start_hint_sequence() -> void:
	# Таймер на 10 секунд
	await get_tree().create_timer(10.0).timeout
	
	# Проверяем, открыта ли еще сцена после 10 секунд
	if visible:
		_animate_hint()


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


func _on_admit_button_pressed() -> void:
	hide()


func _on_game_started() -> void:
	match lang:
		"rus":
			introduction.text = "Товарищ комендант,\n %s\n\nУправление назначило вас восстановить лагерь Mod'Gerh после саботажа предыдущего коменданта." % [commandant]
			main_part.text = "Управление ожидает, что лагерь будет восстановлен в срок не позднее одного месяца. Вам выделили для этого финансирование"
			conclusion.text = "Учтите, Управление не потерпит провала или безрасудной траты выделенного вам финансирования. Помните о долге и выполняйте приказы!"
		"eng":
			introduction.text = "Comrade Commandant,\n %s\n\nThe Directorate has appointed you to restore the Mod'Gerh camp following the sabotage by the previous commandant." % [commandant]
			main_part.text = "The Directorate expects the camp to be restored within no later than one month. Funding has been allocated to you for this purpose."
			conclusion.text = "Bear in mind, the Directorate will not tolerate failure or the reckless squandering of the funding granted to you. Remember your duty and obey your orders!"
		_:
			"Язык не найден"
	
	show()


func _on_superviser_arrived() -> void:
	match lang:
		"rus":
			introduction.text = "Товарищ комендант,\n %s\n\nУправление направило к вам Супервайзера для проверки вашего штата." % ["Nicola Costa"]
			main_part.text = "Его главная задача проверить ваш персонал, в том числе и вас, когда весь персонал будет проверен."
			conclusion.text = "Заметьте, что он прямой подчиненный Управления и если вы допустите ошибку - он непременно захочет быстрее приблизиться к вам."
		"eng":
			introduction.text = "Comrade Commandant,\n %s\n\nThe Directorate has dispatched a Supervisor to inspect your staff." % [""]
			main_part.text = "His primary objective is to inspect your personnel, including yourself once all other staff have been inspected."
			conclusion.text = "Note that he reports directly to The Directorate, and should you make a mistake, he will surely want to close in on you sooner."
		_:
			"Язык не найден"
	
	show()
