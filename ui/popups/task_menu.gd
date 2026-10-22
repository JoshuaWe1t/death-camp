extends CanvasLayer


@onready var description: Label = $PopUp/TextureRect/VBoxContainer/Description
@onready var admit_button: TextureButton = $PopUp/TextureRect/VBoxContainer/HBoxContainer/AdmitButton
@onready var refuse_button: TextureButton = $PopUp/TextureRect/VBoxContainer/HBoxContainer/RefuseButton

var edict_object: Dictionary = {}
var edict_id: String

func _ready() -> void:
	hide()
	
	EventBus.show_edict_popup.connect(_on_show_popup)
	EdictManager.edict_generated.connect(_on_edict_generated)
	
	admit_button.pressed.connect(_on_admit_button_pressed)
	refuse_button.pressed.connect(_on_refuse_button_pressed)


func _on_show_popup() -> void:
	var text: String = ""
	
	text = "Edict: " + edict_object.get("full_name") + "\n\n"
	text += "Reward: " + str(edict_object.get("reward")) + "\n"
	text += "Penalty: " + str(edict_object.get("penalty")) + "\n"
	text += "Action points requarements: " + str(edict_object.get("ap_cost")) + "\n"
	text += "Superviser'll skip : " + str(edict_object.get("supervisor_advance")) + "member of staff\n"
	
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
