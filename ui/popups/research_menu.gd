extends CanvasLayer


@onready var strength_button: TextureButton = $Control/bg/VBoxContainer/HBoxContainer/ButtonsResearch/StrengthButton
@onready var endurance_button: TextureButton = $Control/bg/VBoxContainer/HBoxContainer/ButtonsResearch/EnduranceButton
@onready var mental_activity_button: TextureButton = $"Control/bg/VBoxContainer/HBoxContainer/ButtonsResearch/Mental activityButton"
@onready var title: Label = $Control/bg/VBoxContainer/HBoxContainer/MarginContainer/DescriptionConatiner/Titel
@onready var description: Label = $Control/bg/VBoxContainer/HBoxContainer/MarginContainer/DescriptionConatiner/Description
@onready var execute_button: TextureButton = $Control/bg/MarginContainer/HBoxContainer2/ExecuteButton
@onready var close_btn: TextureButton = $Control/bg/CloseBtn


var current_research_id: String = "res_strength"
var lang: String = Global.lang

func _ready():
	EventBus.show_research_popup.connect(_on_show_research_menu)
	
	strength_button.pressed.connect(_on_strength_button_pressed)
	endurance_button.pressed.connect(_on_endurance_button_pressed)
	mental_activity_button.pressed.connect(_on_mental_activity_button_pressed)
	execute_button.pressed.connect(_on_execute_pressed)
	close_btn.pressed.connect(_on_close_btn_pressed)
	hide()


func _on_show_research_menu() -> void:
	show()
	title.hide()
	description.hide()


func setup_and_show(research_id: String) -> void:
	if not ResearchManager.research_db.has(research_id):
		return
		
	current_research_id = research_id
	var data = ResearchManager.research_db[research_id]
	
	if lang == "rus":
		# Отображаем описание ресурса: требуемое время, выгода, ОД
		title.text = data["name"][lang] + "\n"
		description.text = "Тип: %s\nОписание: %s\nДлительность: %d дн.\nСтоимость: %d ОД\nВыгода: %d ус. ед." % [
			data["type"], data["desc"]["rus"], data["duration"], data["ap_cost"], data["reward"]
		]
	else:
		title.text = data["name"][lang] + "\n"
		description.text = "Type: %s\nDescription: %s\nDuration: %d d.\nCost: %d AP\nReward: %d credits" % [
			data["type"], data["desc"]["eng"], data["duration"], data["ap_cost"], data["reward"]
		]
	
	# Блокируем кнопку, если не хватает ОД или исследование уже идет
	if ActionPointsManager.current_action_points < data["ap_cost"] or ResearchManager.active_researches.has(research_id):
		execute_button.disabled = true
	else:
		execute_button.disabled = false
	
	title.show()
	description.show()


func _on_execute_pressed() -> void:
	if current_research_id != "" and ResearchManager.start_research(current_research_id):
		hide()


func _on_strength_button_pressed():
	print("_on_strength_button_pressed")
	current_research_id = "res_strength"
	setup_and_show(current_research_id)


func _on_endurance_button_pressed():
	print("_on_endurance_button_pressed")
	current_research_id = "res_stamina"
	setup_and_show(current_research_id)


func _on_mental_activity_button_pressed():
	print("_on_mental_activity_button_pressed")
	current_research_id = "res_mental_activity"
	setup_and_show(current_research_id)


func _on_close_btn_pressed() -> void:
	hide()
