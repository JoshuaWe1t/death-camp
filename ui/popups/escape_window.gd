extends CanvasLayer

@onready var info_label: Label = $Control/TextureRect/VBoxContainer/InfoLabel
@onready var escape_button: TextureButton = $Control/TextureRect/VBoxContainer/HBoxContainer/EscapeButton
@onready var cancel_button: TextureButton = $Control/TextureRect/VBoxContainer/HBoxContainer/CancelButton
var lang = Global.lang

func _ready() -> void:
	# Подключаем сигналы кнопок
	escape_button.pressed.connect(_on_escape_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	
	EventBus.show_escaped_popup.connect(_on_show_escaped_window)
	
	_update_ui()


func _update_ui() -> void:
	# Получаем текущие ОД из глобального менеджера
	var current_ap: int = ActionPointsManager.current_action_points
	
	# Проверяем условие: ОД должно быть строго больше 2
	if current_ap > 2:
		escape_button.disabled = false
		if lang == "rus": 
			info_label.text = "Организовать побег?\nЭто потратит все ваши ОД (Текущие ОД: %d)." % current_ap
		else:
			info_label.text = "Stage an escape?\nThis will consume all your AP (Current AP: %d)." % current_ap
	else:
		escape_button.disabled = true
		if lang == "rus": 
			info_label.text = "Невозможно организовать побег.\nТребуется более 2 ОД (Текущие ОД: %d)." % current_ap
		else:
			info_label.text = "Cannot stage an escape.\nRequires more than 2 AP (Current AP: %d)." % current_ap

func _on_escape_pressed() -> void:
	var current_ap: int = ActionPointsManager.current_action_points
	
	if current_ap > 2:
		# 1. Тратим все оставшиеся очки действия
		ActionPointsManager.spend_ap(current_ap)
		
		# 2. Рассчитываем количество сбежавших заключенных
		var escaped_count: int = randi_range(5, 8)
		
		# 3. Вычитаем сбежавших из общего пула заключенных
		# Используем существующий метод менеджера для списания
		PrisonersManager.escaped_prisoners(escaped_count)
		
		print("Побег успешно организован. Сбежало заключенных: ", escaped_count)
		
		_close_window()


func _on_cancel_pressed() -> void:
	_close_window()


func _close_window() -> void:
	hide()


func _on_show_escaped_window() -> void:
	_update_ui()
	show()
