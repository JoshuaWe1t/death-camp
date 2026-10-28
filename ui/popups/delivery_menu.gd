extends CanvasLayer

@onready var title: Label = $Control/TextureRect/VBoxContainer/Title
@onready var description: Label = $Control/TextureRect/VBoxContainer/Description
@onready var furniture_button: TextureButton = $Control/TextureRect/VBoxContainer/HBoxContainer/FurnitureButton
@onready var clothes_button: TextureButton = $Control/TextureRect/VBoxContainer/HBoxContainer/ClothesButton
@onready var cancel_button: TextureButton = $Control/TextureRect/CancelButton

var lang: String = Global.lang

func _ready() -> void:
	hide()
	
	EventBus.show_dispatch_menu.connect(_on_show_dispatch_menu)
	
	furniture_button.pressed.connect(_on_furniture_button_pressed)
	clothes_button.pressed.connect(_on_clothes_button_pressed)
	cancel_button.pressed.connect(_on_cancel_button_pressed)


func _on_show_dispatch_menu() -> void:
	if lang == "rus":
		title.text = "Станция отправки"
		description.text = "Выберите ресурс для отправки\n\n"
		description.text += "Мебели произведенно %d\n" % [ResourceManager.resource_stock.get("furniture")]
		description.text += "Одежды произведенно %d\n" % [ResourceManager.resource_stock.get("clothes")]
	else:
		title.text = "Transit Depot"
		description.text = "Select a resource to dispatch\n\n"
		description.text += "Furniture Produced: %d\n" % [ResourceManager.resource_stock.get("furniture")]
		description.text += "Clothing Produced: %d\n" % [ResourceManager.resource_stock.get("clothes")]
	show()


func _on_furniture_button_pressed() -> void:
	EventBus.resource_dispatched.emit("furniture", ResourceManager.resource_stock.get("furniture"))


func _on_clothes_button_pressed() -> void:
	EventBus.resource_dispatched.emit("clothes", ResourceManager.resource_stock.get("clothes"))


func _on_cancel_button_pressed() -> void:
	hide()
