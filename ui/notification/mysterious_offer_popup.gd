extends CanvasLayer

@onready var admit_button: TextureButton = $Control/TextureRect/AdmitButton
@onready var refused_button: TextureButton = $Control/TextureRect/RefusedButton
@onready var introduction: Label = $Control/TextureRect/MarginContainerIntro/Introduction
@onready var main_part: Label = $Control/TextureRect/MarginContainerMainPart/MainPart
@onready var conclusion: Label = $Control/TextureRect/MarginContainerConclusion/Conclusion
@onready var hint: Label = $Control/Hint

var hint_tween: Tween
var lang: String = Global.lang
var commandant: String = "Nicola Costa"

func _ready() -> void:
	hide()
	hint.modulate.a = 0.0 # Изначально делаем надпись прозрачной
	
	# Подключаем сигнал, который срабатывает при вызове show() или hide()
	visibility_changed.connect(_on_visibility_changed)
	
	admit_button.pressed.connect(_on_admit_button_pressed)
	refused_button.pressed.connect(_on_refused_button_pressed)
	
	EventBus.show_mysterious_offer.connect(_on_show_mysterious_offer)


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
	EventBus.mysterious_offer_accepted.emit()
	hide()


func _on_refused_button_pressed() -> void:
	EventBus.mysterious_offer_refused.emit()
	hide()


func _on_show_mysterious_offer() -> void:
	match lang:
		"rus":
			introduction.text = "Дорогой комендант,\n %s\n\nЯ поражен тому сколько ты сделал, чтобы пережить весь тот кошмар, что настиг твою семью." % [commandant]
			main_part.text = "Я понимаю твое положение. Тебе страшно и ты понимаешь, что Супервайзер рано или поздно доберется до тебя и тогда судьба твоя не завидна"
			conclusion.text = "Я предлагаю помощь. Собери для меня души заключенных, методы ты и так знаешь, а я дарую тебе спасение. Примешь мое предложение?"
		"eng":
			introduction.text = "Dear Commandant,\n %s\n\nI am astonished by how much you have done to survive the sheer nightmare that befell your family." % [commandant]
			main_part.text = "I understand your predicament. You are terrified, knowing full well that sooner or later the Supervisor will get to you, and when he does, your fate will be unenviable."
			conclusion.text = "I offer you a helping hand. Harvest the souls of the prisoners for me—you already know the methods—and I will grant you salvation. Do you accept my offer?"
		_:
			"Язык не найден"
	
	show()
