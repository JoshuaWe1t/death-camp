extends CanvasLayer

# --- Ссылки на UI элементы ---
@onready var day_label = $UI/DayContainer/DayLabel
@onready var ap_label = $UI/ActionContainer/VBoxContainer/APLabel

@onready var staff_label = $UI/RightPanel/VBoxContainer/ResourcesHBox/StaffContainer/StaffLabel
@onready var prisoners_label = $UI/RightPanel/VBoxContainer/ResourcesHBox/PrisonersContainer/PrisonersLabel
@onready var souls_label = $UI/RightPanel/VBoxContainer/ResourcesHBox/SoulsContainer/SoulsLabel
@onready var funds_label = $UI/RightPanel/VBoxContainer/ResourcesHBox/FundsContainer/FundsLabel

@onready var tasks_vbox: VBoxContainer = $UI/RightPanel/VBoxContainer/TasksVBox

# Кнопки для тестирования цикла
@onready var btn_spend = $UI/ActionContainer/VBoxContainer/SpendAPButton
@onready var btn_end_day = $UI/ActionContainer/VBoxContainer/EndDayButton

var lang = Global.lang

func _ready() -> void:
	# Подписываемся на события цикла
	EventBus.day_started.connect(_on_day_started)
	EventBus.ap_changed.connect(_on_ap_changed)
	EventBus.soul_quota_updated.connect(_on_soul_quota_updated)
	
	# Подписываемся на сигналы указов
	EdictManager.edict_accepted.connect(_on_edict_accepted)
	EdictManager.edict_updated.connect(_on_edict_updated)
	EdictManager.edict_completed.connect(_remove_edict_from_hud)
	EdictManager.edict_failed.connect(_remove_edict_from_hud)
	EdictManager.edict_refused.connect(_remove_edict_from_hud)
	
	# Подключаем тестовые кнопки
	btn_spend.pressed.connect(_on_spend_pressed)
	btn_end_day.pressed.connect(_on_end_day_pressed)
	
	# Очищаем контейнер от тестовых надписей при старте
	for child in tasks_vbox.get_children():
		child.queue_free()	
	
	for task_id in EdictManager.active_edicts:
		_on_edict_accepted(EdictManager.active_edicts[task_id])
	
	# Первичная отрисовка статических ресурсов
	update_static_resources()


func _process(_delta: float) -> void:
	update_static_resources()


func update_static_resources() -> void:
	staff_label.text = str(StaffManager.current_stuff)
	prisoners_label.text = str(PrisonersManager.current_prisoners)
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


func _on_spend_pressed() -> void:
	ActionPointsManager.spend_ap(1)


func _on_end_day_pressed() -> void:
	Global.end_day()


func _on_soul_quota_updated(collected: int, required: int) -> void:
	var quota_node_name = "SoulQuotaTask"
	var label = tasks_vbox.get_node_or_null(quota_node_name)
	
	# Если задание почему-то требует 0 душ (или пакт отменен/сброшен), скрываем метку
	if required <= 0:
		if label:
			label.queue_free()
		return
		
	# Если метки еще нет (например, пакт только что приняли), создаем ее
	if not label:
		label = Label.new()
		label.name = quota_node_name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		# Выделим текст красным цветом, чтобы это задание бросалось в глаза
		label.add_theme_color_override("font_color", Color.CRIMSON) 
		tasks_vbox.add_child(label)
		
	# Обновляем текст (например: "Квота душ: (5/15)")
	if lang == "rus":
		label.text = "Квота душ: (" + str(collected) + "/" + str(required) + ")"
	else:
		label.text = "Soul Quota: (" + str(collected) + "/" + str(required) + ")"
	
	# Если квота выполнена, можно опционально поменять цвет на зеленый/обычный
	if collected >= required:
		label.add_theme_color_override("font_color", Color.WEB_GREEN)
	else:
		label.add_theme_color_override("font_color", Color.CRIMSON)


# --- Стандартные указы ---
func _on_edict_accepted(task: Dictionary) -> void:
	var label = Label.new()
	label.name = str(task["instance_id"]).validate_node_name()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	_update_label_text(label, task)
	tasks_vbox.add_child(label)


func _on_edict_updated(task: Dictionary) -> void:
	var safe_name = str(task["instance_id"]).validate_node_name()
	var label = tasks_vbox.get_node_or_null(safe_name)
	if label:
		_update_label_text(label, task)


func _remove_edict_from_hud(task: Dictionary) -> void:
	var safe_name = str(task["instance_id"]).validate_node_name()
	var label = tasks_vbox.get_node_or_null(safe_name)
	if label:
		label.queue_free()


func _update_label_text(label: Label, task: Dictionary) -> void:
	var text = task["full_name"]
	
	# Если это задание на производство, добавляем формат (0/20)
	if task.has("required_quantity"):
		var current = task.get("current_quantity", 0)
		var required = task["required_quantity"]
		text += " (" + str(current) + "/" + str(required) + ")"
		
	label.text = text
