extends CanvasLayer

# Перетащи сюда сцену StaffMemberRow.tscn через инспектор
@export var row_scene: PackedScene 
@onready var list_container: VBoxContainer = $Control/MarginContainer/TextureRect/MarginContainer/ScrollContainer/ListContainer


func _ready() -> void:
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
