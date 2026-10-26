extends CanvasLayer

@export var row_scene: PackedScene 
@onready var list_container: VBoxContainer = $Control/MarginContainer/TextureRect/MarginContainer/ScrollContainer/ListContainer
@onready var close_button: TextureButton = $Control/CloseButton


func _ready() -> void:
	hide()
	
	EventBus.show_staff_list.connect(_on_show_staff_list)
	EventBus.staff_list_updated.connect(_populate_list)
	close_button.pressed.connect(_on_close_button_pressed)
	
	_populate_list()


func _populate_list() -> void:
	# Очистка контейнера на случай повторного открытия
	for child in list_container.get_children():
		child.queue_free()
		
	# Получаем массив из StaffManager и генерируем строки
	for member in StaffManager.staff_list:
		var row = row_scene.instantiate()
		list_container.add_child(row)
		row.set_data(member)


func _on_show_staff_list() -> void:
	_populate_list() # Перерисовываем список прямо перед открытием окна на случай рассинхрона
	show()


func _on_close_button_pressed() -> void:
	hide()
