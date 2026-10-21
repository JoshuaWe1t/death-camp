extends CanvasLayer

# --- Ссылки на UI элементы ---
@onready var day_label = $UI/DayContainer/DayLabel
@onready var ap_label = $UI/ActionContainer/VBoxContainer/APLabel

@onready var staff_label = $UI/RightPanel/VBoxContainer/ResourcesHBox/StaffContainer/StaffLabel
@onready var prisoners_label = $UI/RightPanel/VBoxContainer/ResourcesHBox/PrisonersContainer/PrisonersLabel
@onready var souls_label = $UI/RightPanel/VBoxContainer/ResourcesHBox/SoulsContainer/SoulsLabel
@onready var funds_label = $UI/RightPanel/VBoxContainer/ResourcesHBox/FundsContainer/FundsLabel

# Кнопки для тестирования цикла
@onready var btn_spend = $UI/ActionContainer/VBoxContainer/SpendAPButton
@onready var btn_end_day = $UI/ActionContainer/VBoxContainer/EndDayButton

func _ready() -> void:
	# Подписываемся на события цикла
	EventBus.day_started.connect(_on_day_started)
	EventBus.ap_changed.connect(_on_ap_changed)
	
	# Подключаем тестовые кнопки
	btn_spend.pressed.connect(_on_spend_pressed)
	btn_end_day.pressed.connect(_on_end_day_pressed)
	
	# Первичная отрисовка статических ресурсов
	update_static_resources()


func update_static_resources() -> void:
	staff_label.text = str(StaffManager.current_stuff)
	prisoners_label.text = str(PrisonersManager.current_prizoners)
	souls_label.text = str(PrisonersManager.prisoners_souls)
	funds_label.text = str(FundsManager.current_funds) + "$"


func _on_day_started(day: int) -> void:
	# Таймер в левом верхнем углу
	var days_left = Global.TOTAL_DAYS - day
	day_label.text = str(days_left) + " days"
	
	# Обновляем ОД на старте дня
	_on_ap_changed(ActionPointsManager.current_action_points)


func _on_ap_changed(new_ap: int) -> void:
	# ОД по центру в формате "1/10"
	ap_label.text = str(new_ap) + "/" + str(ActionPointsManager.MAX_ACTION_POINTS)
	
	# Блокируем кнопку трат, если ОД кончились
	btn_spend.disabled = new_ap <= 0


# --- Обработчики тестовых кнопок ---
func _on_spend_pressed() -> void:
	ActionPointsManager.spend_ap(1)


func _on_end_day_pressed() -> void:
	Global.end_day()
