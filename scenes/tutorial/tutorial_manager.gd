extends CanvasLayer


var steps: Array[Dictionary] = [
	{ "width": 0, "height": 0, "pos_x": 640, "pos_y": 360, 
		"text": {
			"rus": "",
			"eng": ""
	}},
	{ "width": 0, "height": 0, "pos_x": 480, "pos_y": 280, 
		"text": {
			"rus": "Чтобы показать/скрыть меню обучения нажмите [ESC].\n[ЛКМ] - следующая подсказка/[ПКМ] - предыдущая подсказка",
			"eng": "Press [ESC] to show/hide the tutorial menu.\n[LMB] - Next tip / [RMB] - Previous tip"
	}},
	{ "width": 0, "height": 0, "pos_x": 480, "pos_y": 280, 
		"text": {
			"rus": "Чтобы показать названия построек зажмите [SPACE]",
			"eng": "Hold [SPACE] to reveal structure names"
	}},
	{ "width": 54, "height": 28, "pos_x": 613, "pos_y": 0, 
		"text": {
			"rus": "Это ваши Очки действия (ОД), они нужны для выполнения действий",
			"eng": "These are your Action Points (AP), required to perform actions."
	}},
	{ "width": 82, "height": 38, "pos_x": 0, "pos_y": 4, 
		"text": {
			"rus": "Ваши оставшиеся дня для выполнения основного задания",
			"eng": "Days remaining to complete the primary objective."
	}},
	{ "width": 440, "height": 48, "pos_x": 832, "pos_y": 8, 
		"text": {
			"rus": "Панель ресурсов колонии. Наведите курсор на иконку ресурса, чтобы узнать его наименование",
			"eng": "Facility Resource Panel. Hover over a resource icon to view its details."
	}},
	{ "width": 285, "height": 141, "pos_x": 994, "pos_y": 60, 
		"text": {
			"rus": "Панель активных заданий",
			"eng": "Active Directives Panel"
	}},
	{ "width": 110, "height": 75, "pos_x": 187, "pos_y": 8, 
		"text": {
			"rus": "Чтобы прочитать информацию о здании наведитесь на него курсором",
			"eng": "Hover over a building to view its status and details."
	}},
	{ "width": 221, "height": 113, "pos_x": 216, "pos_y": 110, 
		"text": {
			"rus": "Кликниет [ЛКМ] чтобы открыть доступное меню здания (исследования, восстановление и др.)",
			"eng": "[LMB] Click to open the building menu (research, restoration, etc.)."
	}},
	{ "width": 110, "height": 75, "pos_x": 187, "pos_y": 8, 
		"text": {
			"rus": "(Кликниет [ЛКМ]) Резиденция коменданта позволяет закончить день",
			"eng": "([LMB] Click) Commandant's Residence allows you to end the day."
	}},
	{ "width": 221, "height": 113, "pos_x": 216, "pos_y": 110, 
		"text": {
			"rus": "(Кликниет [ЛКМ]) Администрация открывает меню штата",
			"eng": "([LMB] Click) Administration opens the Staff Roster."
	}},
	{ "width": 55, "height": 58, "pos_x": 162, "pos_y": 372, 
		"text": {
			"rus": "(Кликниет [ЛКМ]) Станция отправки позволяет отправлять произведенные ресурсы",
			"eng": "([LMB] Click) Dispatch Station enables dispatching manufactured resources."
	}},
	{ "width": 147, "height": 58, "pos_x": 402, "pos_y": 522, 
		"text": {
			"rus": "(Кликниет [ЛКМ]) Постройки как Стена смерти позволяет казнить заключенных",
			"eng": "([LMB] Click) Structures like the Death Wall allow prisoner executions."
	}},
	{ "width": 208, "height": 82, "pos_x": 459, "pos_y": 221, 
		"text": {
			"rus": "(Кликниет [ЛКМ]) Барраки позволяют саботировать работу и помогать заключенным сбегать",
			"eng": "([LMB] Click) Barracks allow you to sabotage operations and aid prisoner escapes."
	}},
	{ "width": 174, "height": 82, "pos_x": 686, "pos_y": 313, 
		"text": {
			"rus": "(Кликниет [ЛКМ]) Постройки как Лаборатория позволяют проводить исследования/эксперименты",
			"eng": "([LMB] Click) Facilities like the Laboratory allow conducting research and experiments."
	}},
	{ "width": 195, "height": 82, "pos_x": 719, "pos_y": 403, 
		"text": {
			"rus": "(Кликниет [ЛКМ]) Цеха позволяют производить ресурсы",
			"eng": "([LMB] Click) Workshops allow you to produce resources."
	}}
]

var current_index: int = 0
var is_tutorial_active: bool = false
var lang = Global.lang


static var has_played_on_start: bool = false

@onready var ui_container = $TutorialUI
@onready var highlight_frame = $TutorialUI/HighlightFrame
@onready var text_box: PanelContainer = $TutorialUI/TextBox
@onready var text_label = $TutorialUI/TextBox/TextLabel

func _ready():
	if not has_played_on_start:
		start_tutorial()
		has_played_on_start = true
	else:
		hide_tutorial()


func _process(_delta):
	if is_tutorial_active:
		# Анимация плавного свечения через синусоиду (меняем прозрачность от 0.4 до 1.0)
		var time = Time.get_ticks_msec() / 1000.0
		highlight_frame.modulate.a = (sin(time * 5.0) + 1.0) / 2.0 * 0.6 + 0.4


# Обработка ввода
func _input(event):
	# Нажатие на Escape (в Godot экшен ui_cancel по умолчанию привязан к Esc)
	if event.is_action_pressed("ui_cancel"):
		if is_tutorial_active:
			hide_tutorial()
		else:
			start_tutorial()
		# Поглощаем ввод, чтобы игра не поставилась на паузу, если у вас есть такое меню
		get_viewport().set_input_as_handled()

	# Управление кликами мыши
	if is_tutorial_active and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			next_step()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			prev_step()


func start_tutorial():
	if steps.is_empty(): return
	
	is_tutorial_active = true
	current_index = 0
	ui_container.show()
	update_ui()


func next_step():
	current_index += 1
	if current_index >= steps.size():
		hide_tutorial()
	else:
		update_ui()


func prev_step():
	current_index -= 1
	if current_index < 0:
		current_index = 0
	update_ui()


func update_ui():
	var step = steps[current_index]
	
	# В Godot позиция и размер задаются через Vector2
	highlight_frame.size = Vector2(step["width"], step["height"])
	highlight_frame.position = Vector2(step["pos_x"], step["pos_y"])
	
	text_label.text = step["text"][lang]

	# Если хотите, чтобы окно текста автоматически "прилипало" под рамку, раскомментируйте это:
	text_box.position = Vector2(step["pos_x"], step["pos_y"] + step["height"] + 20)


func hide_tutorial():
	is_tutorial_active = false
	ui_container.hide()
