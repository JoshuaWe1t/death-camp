extends CanvasLayer


@onready var resist_button: TextureButton = $Control/bg/VBoxContainer/HBoxContainer/ButtonsResearch/ResistButton
@onready var combinatories_button: TextureButton = $Control/bg/VBoxContainer/HBoxContainer/ButtonsResearch/CombinatoriesButton

@onready var titel: Label = $Control/bg/VBoxContainer/HBoxContainer/MarginContainer/DescriptionConatiner/Titel
@onready var description: Label = $Control/bg/VBoxContainer/HBoxContainer/MarginContainer/DescriptionConatiner/Description
@onready var execute_button: TextureButton = $Control/bg/MarginContainer/HBoxContainer2/ExecuteButton



var current_research_id: String = "res_strength"


func _ready():
	EventBus.show_experiment_menu.connect(_on_show_experiment_menu)
	
	resist_button.pressed.connect(_on_resist_button_pressed)
	combinatories_button.pressed.connect(_on_combinatories_button_pressed)
	execute_button.pressed.connect(_on_execute_pressed)
	hide()


func _on_show_experiment_menu() -> void:
	show()
	titel.hide()
	description.hide()


func setup_and_show(research_id: String) -> void:
	if not ResearchManager.research_db.has(research_id):
		return
		
	current_research_id = research_id
	var data = ResearchManager.research_db[research_id]
	
	# Отображаем описание ресурса: требуемое время, выгода, ОД
	titel.text = data["name"] + "\n"
	description.text = "Тип: %s\nОписание: %s\nДлительность: %d дн.\nСтоимость: %d ОД\nВыгода: %d ус. ед." % [
		data["type"], data["desc"]["rus"], data["duration"], data["ap_cost"], data["reward"]
	]
	
	# Блокируем кнопку, если не хватает ОД или исследование уже идет
	if ActionPointsManager.current_action_points < data["ap_cost"] or ResearchManager.active_researches.has(research_id):
		execute_button.disabled = true
	else:
		execute_button.disabled = false
	
	titel.show()
	description.show()


func _on_execute_pressed() -> void:
	if current_research_id != "" and ResearchManager.start_research(current_research_id):
		hide()


func _on_resist_button_pressed():
	print("_on_resist_button_pressed")
	current_research_id = "exp_resistance"
	setup_and_show(current_research_id)


func _on_combinatories_button_pressed():
	print("_on_combinatories_button_pressed")
	current_research_id = "exp_combinatorics"
	setup_and_show(current_research_id)
