extends CanvasLayer


@onready var description: Label = $PopUp/TextureRect/VBoxContainer/Description
@onready var admit_button: TextureButton = $PopUp/TextureRect/HBoxContainer/AdmitButton
@onready var refuse_button: TextureButton = $PopUp/TextureRect/HBoxContainer/RefuseButton
@onready var texture_rect: TextureRect = $PopUp/TextureRect


var edict_object: Dictionary = {}
var edict_id: String


func _ready() -> void:
	hide()
	
	EventBus.show_edict_popup.connect(_on_show_popup)
	EdictManager.edict_generated.connect(_on_edict_generated)
	
	admit_button.pressed.connect(_on_admit_button_pressed)
	refuse_button.pressed.connect(_on_refuse_button_pressed)
	
	texture_rect.texture = TextureDatabase.DATA.get("decree").get(Global.lang).get("texture")
	admit_button.texture_normal = TextureDatabase.DATA.get("decree").get(Global.lang).get("admit_button").get("normal")
	refuse_button.texture_normal = TextureDatabase.DATA.get("decree").get(Global.lang).get("refuse_button").get("normal")
	admit_button.texture_pressed = TextureDatabase.DATA.get("decree").get(Global.lang).get("admit_button").get("pressed")
	refuse_button.texture_pressed = TextureDatabase.DATA.get("decree").get(Global.lang).get("refuse_button").get("pressed")


func _on_show_popup() -> void:
	var text: String = ""
	if Global.lang  == "rus":
		text = edict_object.get("full_name") + "\n\n"
		text += "Награда: " + str(edict_object.get("reward")) + "\n"
		text += "Штраф: " + str(edict_object.get("penalty")) + "\n"
		text += "Требуется очков действий: " + str(edict_object.get("ap_cost")) + "\n"
		text += "Супервайзер пропустит: " + str(edict_object.get("supervisor_advance")) + " членов штата\n"
	else:
		text = edict_object.get("full_name") + "\n\n"
		text += "Reward: " + str(edict_object.get("reward")) + "\n"
		text += "Penalty: " + str(edict_object.get("penalty")) + "\n"
		text += "Action points requarements: " + str(edict_object.get("ap_cost")) + "\n"
		text += "Superviser'll skip : " + str(edict_object.get("supervisor_advance")) + " member of staff\n"
	
	description.text = text
	show()


func _on_edict_generated(edict: Dictionary) -> void:
	print("Edict._on_edict_generated")
	edict_object = edict
	edict_id = edict_object.get("instance_id")


func _on_admit_button_pressed() -> void:
	print("Edict._on_admit_button_pressed")
	EdictManager.accept_edict(edict_id)
	hide()


func _on_refuse_button_pressed() -> void:
	print("Edict._on_refuse_button_pressed")
	EdictManager.refuse_edict(edict_id)
	hide()
