extends Control

const MENU = preload("res://scenes/menus/main_menu/main_menu.tscn")

signal show_hint_go_menu()

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var timer: Timer = $Timer
@onready var hint: Label = $Hint
@onready var timer_hint: Timer = $TimerHint

var hint_tween: Tween
var is_text_skipped: bool = false

var lang = Global.lang

# Текст, который мы хотим напечатать
var text_to_type = {
	"cons1": {
		"rus": "Вы уцелели, и супервайзер покинул территорию ни с чем. Вы пожертвовали достаточным количеством душ для спасения, но теперь стали неотъемлемой частью этого места. Вы обречены вечность мучиться в стенах лагеря, продолжая собирать чужие жизни, чтобы до конца расплатиться за свою сделку",
		"eng": "You survived, and the supervisor left the grounds empty-handed. You sacrificed enough souls to buy your salvation, but now you have become an inseparable part of this place. You are condemned to linger within the camp’s walls for eternity, harvesting the lives of others to pay off your bargain."
	},
	"cons2":  {
		"rus": "За отведенное время вы завершили все указы руководства, и лагерь продолжает свою работу. Опасность миновала, а супервайзер был отозван. Вы сохранили свою жизнь, но до самого финала этой истории вам предстоит каждый день носить чужую маску, притворяясь тем чудовищем, которым вы не являетесь.",
		"eng": "Within the allotted time, you carried out every directive from headquarters, ensuring the facility remains operational. The danger has passed, and the supervisor was recalled. You kept your life, but until the very end, you must wear another's mask day after day, pretending to be the monster you are not."
	},
	"cons3":  {
		"rus": "Супервайзер оказался быстрее и достиг вас раньше, чем вы нашли способ спастись. Вам не удалось утаить свою «грязную кровь», и все тайное стало явным. Теперь вы лишены статуса управляющего и сами стали одним из заключенных. Шагая в строю своего отряда, вы с ужасом смотрите на здание впереди — ведь вы, как никто другой, знаете, что именно там происходит.",
		"eng": "The supervisor proved faster, catching up to you before you could secure an escape. You failed to conceal your tainted blood, and the truth came to light. Stripped of your administrator status, you are now just another inmate. Marching in formation with your squad, you stare in dread at the structure ahead—knowing better than anyone what truly happens behind those doors."
	},
	"cons4":  {
		"rus": "Вы не справились с распределением бюджета и исчерпали доступное финансирование. Лагерь был признан убыточным и экстренно закрыт. Во время перевода в другие учреждения части заключенных удалось совершить побег, но удача обошла вас стороной. Теперь, лишившись должности, вы покорно ожидаете отправки в новый лагерь в качестве узника.",
		"eng": "You mismanaged the budget and drained all available funding. Deemed unprofitable, the facility was abruptly decommissioned. During transfer to other installations, several prisoners managed to break out, but luck was not on your side. Discharged from your post, you submissively await transit to another camp as an inmate."
	},
	"cons5":  {
		"rus": "Отведенные 30 дней истекли, а здания так и не были восстановлены. Без видимых результатов проект был признан нерентабельным и навсегда заброшен. Вы проиграли и оказались в рядах заключенных. Вашим единственным утешением перед неизбежным финалом остается лишь одна мысль: в этом мире стало на одно проклятое место меньше.",
		"eng": "The thirty allotted days ran out, and the structures were never restored. Lacking tangible results, the project was deemed unviable and abandoned for good. You failed, ending up among the ranks of the incarcerated. Before the inevitable end, a single thought offers cold comfort: this world now holds one less cursed place."
	},
	"cons6":  {
		"rus": "Рискуя собой, вы смогли организовать спасение части людей. Вы сами стали узником, но спасенные жизни дают вам надежду на то, что вы смогли остаться человеком. Теперь вы можете спокойно закрыть глаза и смиренно дождаться звуков приближающейся расправы супервайзера над вами.",
		"eng": "At great personal risk, you managed to orchestrate the escape of several souls. You became an inmate yourself, yet the lives you saved leave you with hope that you retained your humanity. Now you can close your eyes in peace, serenely awaiting the approaching sounds of the supervisor's retribution."
	}
}


func _ready():
	hint.text = "Левый клик, чтобы показать весь текст" if lang == "rus" else "Left-click to reveal full text"
	show_hint_go_menu.connect(_on_show_hint_go_menu)
	timer_hint.timeout.connect(_on_timer_hint)
	
	hint.modulate.a = 0.0 # Изначально делаем надпись прозрачной
	
	EventBus.game_won.connect(_on_game_end)
	EventBus.game_lost.connect(_on_game_end)
	
	_on_game_end("cons4")


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
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
	if event.is_action_pressed("LBM"):
		is_text_skipped = true
		# Сразу показываем весь текст и останавливаем таймер
		rich_text_label.visible_characters = rich_text_label.text.length()
		timer.stop()
		show_hint_go_menu.emit()
	
	if event.is_action_pressed("SPACE") and is_text_skipped:
		print("Переход в игру")
		get_tree().change_scene_to_packed(MENU)


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



func _on_show_hint_go_menu() -> void:
	hint.text = "Нажмите [Space] чтобы вернуться в меню" if lang == "rus" else "Press [Space] to go to Menu"


func _on_game_end(id: String) -> void:
	var cons = id
	text_to_type = text_to_type.get(cons).get(lang)
	# Инициализируем текст, но скрываем все символы
	rich_text_label.text = text_to_type
	rich_text_label.visible_characters = 0
	
	# Настраиваем и запускаем таймер
	timer.wait_time = 0.116 # Скорость печати (в секундах на одну букву)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _on_timer_hint() -> void:
	_animate_hint()
